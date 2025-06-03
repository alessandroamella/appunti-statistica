#!/usr/bin/env node

const fs = require("node:fs");
const path = require("node:path");
const { execSync } = require("node:child_process");
const { Octokit } = require("@octokit/rest");
const dotenv = require("dotenv-safe");
const tmp = require("tmp");
const { format } = require("date-fns");
const archiver = require("archiver");

// Load environment variables from .env file
dotenv.config();

// Configuration from environment variables
const GITHUB_TOKEN = process.env.GITHUB_TOKEN;
const REPO_OWNER = process.env.REPO_OWNER || "alessandroamella";
const REPO_NAME = process.env.REPO_NAME || path.basename(process.cwd());
const PDF_PATTERN = process.env.PDF_PATTERN || "*.pdf";
const RELEASE_PREFIX = process.env.RELEASE_PREFIX || "appunti";

// Parse command line arguments
function parseArgs() {
  const args = process.argv.slice(2);
  const result = { command: args[0], message: "" };

  for (let i = 1; i < args.length; i++) {
    if (args[i] === "-m" && i + 1 < args.length) {
      result.message = args[i + 1];
      i++; // Skip the next argument as it's the message content
    }
  }

  return result;
}

// Validate required environment variables
if (!GITHUB_TOKEN) {
  console.error("Error: GITHUB_TOKEN is required in your .env file");
  process.exit(1);
}

// Initialize GitHub API client
const octokit = new Octokit({
  auth: GITHUB_TOKEN
});

/**
 * Generate PDF using the generate_notes.sh script
 */
function generatePDF() {
  try {
    // Remove LaTeX cache first
    console.log("Removing LaTeX cache using rm_cache.sh...");
    execSync("./rm_cache.sh", { stdio: "inherit" });

    // Generate light version first
    console.log("Generating light PDF using generate_notes.sh...");
    execSync("./generate_notes.sh", { stdio: "inherit" });

    // Check if the PDF was generated correctly
    if (!fs.existsSync("appunti_completi.pdf")) {
      throw new Error("Failed to generate light appunti_completi.pdf");
    }

    console.log("Light PDF generation completed successfully");

    // Save light version with a different name
    fs.copyFileSync("appunti_completi.pdf", "appunti_completi_light.pdf");
    if (!fs.existsSync("appunti_completi_light.pdf")) {
      throw new Error("Failed to save light PDF version");
    }
    console.log("Light PDF saved as appunti_completi_light.pdf");

    // Generate dark version
    console.log("Generating dark PDF using generate_notes.sh --dark...");
    execSync("./generate_notes.sh --dark", { stdio: "inherit" });

    // Check if the dark PDF was generated correctly
    if (!fs.existsSync("appunti_completi.pdf")) {
      throw new Error("Failed to generate dark appunti_completi.pdf");
    }

    // Save dark version with a different name
    fs.copyFileSync("appunti_completi.pdf", "appunti_completi_dark.pdf");
    if (!fs.existsSync("appunti_completi_dark.pdf")) {
      throw new Error("Failed to save dark PDF version");
    }
    console.log("Dark PDF saved as appunti_completi_dark.pdf");
  } catch (error) {
    console.error("Error in PDF generation process:", error.message);
    process.exit(1);
  }
}

/**
 * Find PDF files in the repository and sort them numerically
 */
function findPDFFiles() {
  try {
    // Use find command to get all PDF files
    const result = execSync(`find . -name "${PDF_PATTERN}" | sort -V`).toString().trim();
    const files = result.split("\n").filter(file => file);

    if (files.length === 0) {
      console.log("No PDF files found in the repository.");
      process.exit(0);
    }

    // Filter out appunti_completi.pdf
    const filteredFiles = files.filter(
      file => !file.endsWith("/appunti_completi.pdf") && !file.endsWith("./appunti_completi.pdf")
    );

    return filteredFiles;
  } catch (error) {
    console.error("Error finding PDF files:", error.message);
    process.exit(1);
  }
}

/**
 * Create a ZIP archive of all individual PDFs
 */
async function createZipArchive(pdfFiles) {
  const formattedDate = format(new Date(), "yyyy-MM-dd_HH-mm-ss");
  const zipOutputFileName = `${RELEASE_PREFIX}_all_pdfs_${formattedDate}.zip`;

  // Create temp directory for the operation
  const tmpobj = tmp.dirSync({ unsafeCleanup: true });
  const tempZipPath = path.join(tmpobj.name, zipOutputFileName);

  try {
    console.log("Creating ZIP archive of all PDFs...");
    const outputZip = fs.createWriteStream(tempZipPath);
    const archive = archiver("zip", {
      zlib: { level: 9 } // Sets the compression level.
    });

    archive.pipe(outputZip);

    pdfFiles.forEach(file => {
      archive.file(file, { name: path.basename(file) });
    });

    await archive.finalize();

    if (!fs.existsSync(tempZipPath)) {
      throw new Error("Failed to create ZIP archive");
    }
    console.log(`ZIP archive created: ${zipOutputFileName}`);

    return {
      zipArchive: {
        filePath: tempZipPath,
        fileName: zipOutputFileName
      },
      cleanup: () => tmpobj.removeCallback()
    };
  } catch (error) {
    tmpobj.removeCallback();
    console.error("Error in ZIP processing:", error.message);
    process.exit(1);
  }
}

/**
 * Create a GitHub release with the combined PDF and ZIP archive
 */
async function createGitHubRelease(zipInfo, customMessage = "") {
  const timestamp = Math.floor(Date.now() / 1000);
  const releaseTag = `release-${timestamp}`;
  const formattedDate = format(new Date(), "yyyy-MM-dd HH:mm:ss");
  const releaseName = `${
    RELEASE_PREFIX.charAt(0).toUpperCase() + RELEASE_PREFIX.slice(1)
  } ${formattedDate}`;

  try {
    console.log("Creating GitHub release...");

    // Generate release body with PDF file names in Italian
    const pdfFiles = findPDFFiles();
    const fileList = pdfFiles.map(file => `- ${path.basename(file)}`).join("\n");
    let releaseBody = `Appunti aggiornati al ${formattedDate}.`;

    // Add custom message if provided
    if (customMessage) {
      releaseBody += `\n\n${customMessage}`;
    }

    releaseBody += `\n\nFile inclusi in questa pubblicazione:\n${fileList}`;

    // Create the release
    const release = await octokit.repos.createRelease({
      owner: REPO_OWNER,
      repo: REPO_NAME,
      tag_name: releaseTag,
      name: releaseName,
      body: releaseBody,
      draft: false,
      prerelease: false
    });

    console.log(`GitHub release created: ${releaseName}`);

    // Upload the light PDF asset
    const lightPdfPath = path.join(process.cwd(), "appunti_completi_light.pdf");
    const lightPdfData = fs.readFileSync(lightPdfPath);
    const lightPdfFileName = `${RELEASE_PREFIX}_light_${formattedDate}.pdf`;

    await octokit.repos.uploadReleaseAsset({
      owner: REPO_OWNER,
      repo: REPO_NAME,
      release_id: release.data.id,
      name: lightPdfFileName,
      data: lightPdfData
    });
    console.log(`Light PDF file uploaded to release: ${lightPdfFileName}`);

    // Upload the dark PDF asset
    const darkPdfPath = path.join(process.cwd(), "appunti_completi_dark.pdf");
    const darkPdfData = fs.readFileSync(darkPdfPath);
    const darkPdfFileName = `${RELEASE_PREFIX}_dark_${formattedDate}.pdf`;

    await octokit.repos.uploadReleaseAsset({
      owner: REPO_OWNER,
      repo: REPO_NAME,
      release_id: release.data.id,
      name: darkPdfFileName,
      data: darkPdfData
    });
    console.log(`Dark PDF file uploaded to release: ${darkPdfFileName}`);

    // Upload the ZIP archive asset
    const zipData = fs.readFileSync(zipInfo.zipArchive.filePath);
    await octokit.repos.uploadReleaseAsset({
      owner: REPO_OWNER,
      repo: REPO_NAME,
      release_id: release.data.id,
      name: zipInfo.zipArchive.fileName,
      data: zipData
    });
    console.log(`ZIP archive uploaded to release: ${zipInfo.zipArchive.fileName}`);

    console.log(`Release URL: ${release.data.html_url}`);

    // Clean up
    zipInfo.cleanup();
  } catch (error) {
    zipInfo.cleanup();
    console.error("Error creating GitHub release:", error.message);
    if (error.response) {
      console.error("API response:", error.response.data);
    }
    process.exit(1);
  }
}

/**
 * Main function
 */
async function main() {
  const args = parseArgs();
  const command = args.command;

  switch (command) {
    case "release": {
      // Generate the combined PDF using the shell script
      generatePDF();
      // Find all individual PDFs
      const pdfFiles = findPDFFiles();
      // Create ZIP archive with individual PDFs
      const zipInfo = await createZipArchive(pdfFiles);
      // Create release with generated PDF and ZIP
      await createGitHubRelease(zipInfo, args.message);
      break;
    }

    default:
      console.log("GitHub Auto-Release Script (Node.js version)");
      console.log("----------------------------------------");
      console.log("This script automates creating GitHub releases with combined PDFs.");
      console.log("");
      console.log("Usage:");
      console.log(
        "  node github-auto-release.js release               - Manually trigger a release"
      );
      console.log(
        '  node github-auto-release.js release -m "message" - Trigger a release with a custom message'
      );
      console.log("");
      console.log("Make sure to create a .env file with your GitHub token.");
  }
}

main().catch(error => {
  console.error("Unexpected error:", error);
  process.exit(1);
});
