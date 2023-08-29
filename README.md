# Plandek - deployments

[![Step changelog](https://shields.io/github/v/release/secretescapes/bitrise-step-plandek-deployment?include_prereleases&label=changelog&color=blueviolet)](https://github.com/secretescapes/bitrise-step-plandek-deployment/releases)

Enables you to track and visualize build and deployment events within Plandek's metrics and dashboards.

### Description

Wrapper implementing the Plandek /deployment POST API. Used to complete a deployment within Plandek for a given release cycle.

More details can be found here: https://api.plandek.com/deployments/v1/ui/

### Configuring the Step

By default step should require to set only the `build` property, as long git clone
step was executed before.

## 🧩 Get started

Add this step directly to your workflow in the [Bitrise Workflow Editor](https://devcenter.bitrise.io/steps-and-workflows/steps-and-workflows-index/).

You can also run this step directly with [Bitrise CLI](https://github.com/bitrise-io/bitrise).

## ⚙️ Configuration

### Inputs

| Key | Description | Flags | Default |
| --- | --- | --- | --- |
| `api_token` | Plandek API token.| required, sensitive | |
| `branch_name` | Name of the branch being deployed. | | |
| `build` | Build identifier in your build tool. Typically the version being deployed (e.g. Svc B 10.2.1). | required | |
| `calculate_commits_in_build` | If `true`, Plandek will use the information in your deployment to work out what commits were included in the release. If `false`, you must specify the commits in the commits field. | | `false` |
| `client_key` | Unique identifier for your instance. | required | |
| `commenced_at` | ISO date string including timezone. Used to calculate the time duration of the deployment. | | |
| `commits` | The full commit hash(s) of the release being deployed. | required | |
| `context` | String with any value, which can be used to categorize the deployments. | | |
| `debug` | Will enable bash script debug log mode. | required | `false` |
| `deployed_at` | ISO date string including timezone. Plandek will default to current time if omitted. | | |
| `dry_run` | Will build the Plandek request body and print it, but will not run request itself. | required | `false` |
| `pipeline` | Typically corresponds to the name of your pipeline, workflow, repo, or service under which builds are compiled. If you use the same name pipelines across your organization, we recommend appending additional information to your pipeline name (e.g. repo name) to make it easier to understand your data. | required | `$BITRISE_APP_TITLE` |

## 🙋 Contributing

We welcome [pull requests](https://github.com/secretescapes/bitrise-step-plandek-deployment/pulls) and [issues](https://github.com/secretescapes/bitrise-step-plandek-deployment/issues) against this repository.

For pull requests, work on your changes in a forked repository and use the Bitrise CLI to [run step tests locally](https://devcenter.bitrise.io/bitrise-cli/run-your-first-build/).

Learn more about developing steps:

- [Create your own step](https://devcenter.bitrise.io/contributors/create-your-own-step/)
- [Testing your Step](https://devcenter.bitrise.io/contributors/testing-and-versioning-your-steps/)
