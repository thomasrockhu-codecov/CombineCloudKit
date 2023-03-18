"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.generateSwiftCoverageFiles = void 0;
const fast_glob_1 = __importDefault(require("fast-glob"));
const os_1 = __importDefault(require("os"));
const logger_1 = require("../helpers/logger");
const util_1 = require("./util");
// 1. Find the .profdata files from DerivedData folder
// 2. For each found .profdata file,
//      swiftcov the file
//      1. Separate out the directory as _dir
//      2. For each of app, framework, and xctest
//           1. Get the project name (/meow/meow/blah.app becomes blah)
//           2. If a project was given, or if the name matches ^ (case-insensitive)
//                dest is a misnomer?
//                dest=$([ -f "$f/$_proj" ] && echo "$f/$_proj" || echo "$f/Contents/MacOS/$_proj")
//                _proj_name should be the project name without whitespace
//
//                $1 is the profdata file, $dest is what is above
//                xcrun llvm-cov show -instr-profile "$1" "$dest" > "$_proj_name.$_type.coverage.txt
//
async function generateSwiftCoverageFiles(project) {
    if (!(0, util_1.isProgramInstalled)('xcrun')) {
        throw new Error('xcrun is not installed, cannot process files');
    }
    (0, logger_1.info)('Processing Xcode reports via llvm-cov...');
    const derivedDataDir = `${os_1.default.homedir()}/Library/Developer/Xcode/DerivedData`;
    logger_1.UploadLogger.verbose(`DerivedData folder: ${derivedDataDir}`);
    const profDataFiles = await fast_glob_1.default
        .sync(['**/*.profdata'], {
        cwd: derivedDataDir,
        absolute: true,
        onlyFiles: true,
    });
    (0, logger_1.info)(`Found these profDataFiles: ${profDataFiles}`);
    return profDataFiles;
}
exports.generateSwiftCoverageFiles = generateSwiftCoverageFiles;
//# sourceMappingURL=swift.js.map