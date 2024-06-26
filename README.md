# Template Transformer & Cleanup
This GitHub Action automates the replacement of keywords within a template repository with specified values. It streamlines the process of updating these values, reducing manual effort and potential oversights. For instance, when creating a new repository from the template, manually updating the repository name across all files can be error-prone and time-consuming. This GitHub Action addresses these challenges by automatically performing the necessary replacements, ensuring consistency and saving time.

### How to Create a GitHub Personal Access Token

1. **Log in to GitHub:**
  - Ensure you're logged in to your GitHub account.

2. **Navigate to Personal Access Tokens:**
  - Click on your profile icon in the top-right corner and select **Settings**.
  - In the left sidebar, click on **Developer settings**.
  - Then, click on **Personal access tokens**.

3. **Generate a New Token:**
  - Click on **Generate new token**. You may need to enter your password for authentication.

4. **Configure Token Settings:**
  - Enter a descriptive **Note** to identify the token's purpose (e.g., "Workflow Access Token").
  - Select the following scopes:
    - **repo**
    - **workflow**

5. **Generate Token:**
  - Scroll down and click on **Generate token**.

6. **Copy and Save the Token:**
  - GitHub will display your new personal access token. **Copy it immediately** as it won't be visible later.
  - Add this token to your GitHub organization secrets (Let's say the key name is WORKFLOW_TOKEN).

By following these steps, you can create a GitHub personal access token with `workflow` and `repo` scopes to suit your specific needs.

## Usage
### Example Workflow File
An example workflow to authenticate with GitHub Platform and to push the changes to a specified reference with new changes.
> **NOTE**
> > Create a file under `.github/workflows` directory with the name `default-workflow.yml` and add the following content. This file will be removed once a new repository is created from the template.

```yaml
name: Template Cleanup Workflow

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    permissions:
      contents: write

    steps:
      - name: Checkout repository
        uses: actions/checkout@v2
        with:
          token: ${{ secrets.WORKFLOW_TOKEN }}

      - name: Template Cleanup Action
        uses: thynclabs/template-transformer-and-cleanup@1.0.2
        with:
          search-keyword: 'thynclabs/npm-template'
          replace-keyword: ${{ github.repository }}
          github_url: ${{ github.server_url }}
          workflow_token: ${{ secrets.WORKFLOW_TOKEN }}
          repository: ${{ github.repository }}
          branch: ${{ github.ref }}
```

### Inputs
The following inputs are supported by the GitHub Action:
### Inputs

| Input              | Description                                                                                   | Default Value                |
|--------------------|-----------------------------------------------------------------------------------------------|------------------------------|
| **search_keyword** | The keyword to search for in the template repository.                                         |                              |
| **replace_keyword**| The value to replace the search keyword with.                                                 | `${{ github.repository }}`   |
| **github_url**     | The GitHub server URL. Default value is `${{ github.server_url }}`.                           | `${{ github.server_url }}`   |
| **workflow_token** | The GitHub personal access token with `workflow` and `repo` scopes.                           |                              |
| **repository**     | The repository name. Default value is `${{ github.repository }}`.                             | `${{ github.repository }}`   |
| **branch**         | The branch name. Default value is `${{ github.ref }}`.                                        | `${{ github.ref }}`          |

