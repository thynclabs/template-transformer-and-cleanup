'use strict';
const spawn = require('child_process').spawn;
const path = require('path');

const exec = (cmd, args = [], options = {}) => new Promise((resolve, reject) =>
  spawn(cmd, args, { stdio: 'inherit', ...options })
    .on('close', code => {
      if (code !== 0) {
        return reject(Object.assign(
          new Error(`Invalid exit code: ${code}`),
          { code }
        ));
      };
      return resolve(code);
    })
    .on('error', reject)
);

const trimLeft = (value, charlist = '/') => value.replace(new RegExp(`^[${charlist}]*`), '');
const trimRight = (value, charlist = '/') => value.replace(new RegExp(`[${charlist}]*$`), '');
const trim = (value, charlist) => trimLeft(trimRight(value, charlist));

const main = async () => {
  let branch = process.env.INPUT_BRANCH;
  const repository = process.env.GITHUB_REPOSITORY;
  const github_url_protocol = trim(process.env.INPUT_GITHUB_URL).split('//')[0];
  const github_url = trim(process.env.INPUT_GITHUB_URL).split('//')[1];
  await exec('bash', [path.join(__dirname, './run.sh')], {
    env: {
      ...process.env,
      INPUT_BRANCH: branch,
      INPUT_REPOSITORY: repository,
      INPUT_GITHUB_URL_PROTOCOL: github_url_protocol,
      INPUT_GITHUB_URL: github_url,
    }
  });
};

main().catch(err => {
  console.error(err);
  process.exit(-1);
})

// REPOSITORY=${INPUT_REPOSITORY:-$GITHUB_REPOSITORY}
//   TEXT_TO_REPLACE=${INPUT_TEXT_TO_REPLACE}
