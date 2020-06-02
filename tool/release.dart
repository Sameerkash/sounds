#! /usr/bin/env dshell

import 'dart:io';

import 'package:dshell/dshell.dart';
import 'package:dshell/src/pubspec/pubspec_file.dart';
import 'package:pub_semver/pub_semver.dart';

void main(List<String> args) {
  var parser = ArgParser();
  parser.addFlag('incVersion',
      abbr: 'i',
      defaultsTo: true,
      help: 'Prompts the user to increment the version no.');

  parser.addCommand('help');
  var results = parser.parse(args);

  // only one commmand so it must be help
  if (results.command != null) {
    showUsage(parser);
    exit(0);
  }

  var incVersion = results['incVersion'] as bool;

  // climb the path searching for the pubspec
  var pubspecPath = findPubSpec();
  var projectRootPath = dirname(pubspecPath);
  var pubspec = getPubSpec(pubspecPath);
  var currentVersion = pubspec.version;

  print('Found pubspec.yaml in $pubspecPath');
  print('Current Sounds version is $currentVersion');

  var newVersion = currentVersion;
  if (incVersion) {
    newVersion = incrementVersion(currentVersion, pubspec, pubspecPath);
  }

  // ensure that all code is correctly formatted.
  formatCode(projectRootPath);

  if (tagExists(newVersion.toString())) {
    print('');
    print(red('The tag $newVersion already exists.'));
    if (confirm(
        prompt: 'If you proceed the tag will be deleted and re-created. '
            'Proceed?')) {
      deleteGitTag(newVersion);
    } else {
      exit(1);
    }
  }

  print('generating release notes');
  generateReleaseNotes(projectRootPath, newVersion, currentVersion);

  print('check commit');
  checkCommited();

  print('push release');
  pushRelease();

  print('add tag');
  addGitTag(newVersion);

  print('publish');
  publish(pubspecPath);
}

void formatCode(String projectRootPath) {
  // ensure that all code is correctly formatted.
  print('Formatting code...');
  'dartfmt -w ${join(projectRootPath, 'bin')}'
          ' ${join(projectRootPath, 'lib')}'
          ' ${join(projectRootPath, 'test')}'
      .forEach(devNull, stderr: print);
}

void publish(String pubspecPath) {
  var projectRoot = dirname(pubspecPath);

  'pub publish'.start(workingDirectory: projectRoot, terminal: true);
}

void pushRelease() {
  'git push'.run;
}

/// Check that all files are committed.
void checkCommited() {
  var notCommited = 'git status --porcelain'.toList();

  if (notCommited.isNotEmpty) {
    print('');
    print('You have uncommited files');
    print(orange('You should commit and push them before continuing.'));
    if (confirm(prompt: 'Do you want to list them')) {
      // we get the list again as the user is likely to have
      // committed files after seeing the question.
      notCommited = 'git status --porcelain'.toList();
      print(notCommited.join('\n'));
    }
    if (!confirm(prompt: 'Do you want to continue with the release')) {
      exit(-1);
    }
  }
}

void generateReleaseNotes(
    String projectRootPath, Version newVersion, Version currentVersion) {
  // see https://blogs.sap.com/2018/06/22/generating-release-notes-from-git-commit-messages-using-basic-shell-commands-gitgrep/
  // for better ideas.

  //var currentTag = 'git --no-pager tag --list'.lastLine;

  var currentTag = 'git --no-pager tag --sort=-creatordate'.firstLine;
  // just the messages from each commit
  var messages =
      'git --no-pager log --pretty=format:"%s" $currentTag..HEAD'.toList();
  var changeLogPath = join(projectRootPath, 'CHANGELOG.md');

  var commitMessage = join(projectRootPath, 'commit.msg');
  commitMessage.write('### ${newVersion.toString()}');

  for (var message in messages) {
    commitMessage.append(message);
  }
  commitMessage.append('');

  // give the user a chance to clean up the change log.
  if (confirm(prompt: 'Would you like to clean up the change log')) {
    showEditor(commitMessage);
  }

  // write the edited commit messages to the change log.
  var backup = '$changeLogPath.bak';
  move(changeLogPath, backup);
  read(commitMessage).forEach((line) => changeLogPath.append(line));
  read(backup).forEach((line) => changeLogPath.append(line));
  delete(backup);
  delete(commitMessage);
}

String findPubSpec() {
  var pubspecName = 'pubspec.yaml';
  var cwd = pwd;
  var found = true;

  var pubspecPath = join(cwd, pubspecName);
  // climb the path searching for the pubspec
  while (!exists(pubspecPath)) {
    cwd = dirname(cwd);
    // Have we found the root?
    if (cwd == rootPath) {
      found = false;
      break;
    }
    pubspecPath = join(cwd, pubspecName);
  }

  if (!found) {
    print('Unable to find pubspec.yaml, run release from the'
        'sounds root directory.');
    exit(-1);
  }
  return truepath(pubspecPath);
}

PubSpecFile getPubSpec(String pubspecPath) {
  var pubspec = PubSpecFile.fromFile(pubspecPath);

  // check that the pubspec is ours
  if (pubspec.name != 'sounds') {
    print('Found a pubspec at ${absolute(pubspecPath)} '
        'but it does not belong to sounds. ');
    exit(-1);
  }
  return pubspec;
}

void deleteGitTag(Version newVersion) {
  'git tag -d $newVersion'.run;
  'git push origin :refs/tags/$newVersion'.run;
}

void addGitTag(Version version) {
  if (confirm(prompt: 'Create a git release tag')) {
    var tagName = '$version';

    // Check if the tag already exists and offer to replace it if it does.
    if (tagExists(tagName)) {
      var replace = confirm(
          prompt:
              'The tag $tagName already exists. Do you want to replace it?');
      if (replace) {
        'git tag -d $tagName'.run;
        'git push origin :refs/tags/$tagName'.run;
        print('');
      }
    }

    print('creating git tag');
    // 'git tag -a $tagName'.run;

    'git tag -a $tagName -m "released $tagName"'.run;
  }
}

void showUsage(ArgParser parser) {
  print('''Releases a dart project:
      Increments the version no. in pubspec.yaml
      Regenerates src/util/version.g.dart with the new version no.
      Creates a git tag with the version no. in the form 'v<version-no>'
      Updates the CHANGELOG.md with a new version no. and the set of
      git commit messages.
      Commits the above changes
      Pushes the final results to git
      Runs docker unit tests checking that they have passed (?how)
      Publishes the package using 'pub publish'

      Usage:
      ${parser.usage}
      ''');
}

bool tagExists(String tagName) {
  var tags = 'git tag --list'.toList();

  return (tags.contains(tagName));
}

Version incrementVersion(
    Version version, PubSpecFile pubspec, String pubspecPath) {
  print('');
  print('The current version is $version');
  var options = <NewVersion>[
    NewVersion('Small Patch', version.nextPatch),
    NewVersion('Non-breaking change', version.nextMinor),
    NewVersion('Breaking change', version.nextBreaking),
    NewVersion('Enter custom version no.', null),
  ];

  print('');
  var selected = menu(prompt: 'Select the new version no.', options: options);

  version = selected.version;

  if (version == null) {
    version = getCustomVersion(version);
  }
  print('');

  // recreate the version file
  var soundsRootPath = dirname(pubspecPath);

  print('');
  print('The new version is: $version');
  version = confirmVersion(version);

  print('The accepted version is: $version');

  // write new version.g.dart file.
  var versionPath =
      join(soundsRootPath, 'lib', 'src', 'util', 'version.g.dart');
  print('Regenerating version file at ${absolute(versionPath)}');
  versionPath.write('/// GENERATED BY Sounds tool/release.dart do not modify.');
  versionPath.append('/// Sounds version');
  versionPath.append("String soundsVersion = '$version';");

  // rewrite the pubspec.yaml with the new version
  pubspec.version = version;
  print('pubspec version is: ${pubspec.version}');
  print('pubspec path is: $pubspecPath');
  pubspec.writeToFile(pubspecPath);
  return version;
}

Version confirmVersion(Version version) {
  if (!confirm(prompt: 'Is this the correct version')) {
    try {
      var versionString = ask(prompt: 'Enter the new version: ');

      if (!confirm(prompt: 'Is $versionString the correct version')) {
        exit(1);
      }

      version = Version.parse(versionString);
    } on FormatException catch (e) {
      print(e);
    }
  }
  return version;
}

Version getCustomVersion(Version version) {
  while (version == null) {
    try {
      var entered =
          ask(prompt: 'Enter the new Version No.:', validator: Ask.required);
      version = Version.parse(entered);
    } on FormatException catch (e) {
      print(e);
    }
  }
  return version;
}

class NewVersion {
  String message;
  Version version;

  NewVersion(this.message, this.version);

  String toString() => '$message  (${version ?? "?"})';
}
