# Deploy a Bun application on AWS Lambda
Source: https://bun.com/docs/guides/deployment/aws-lambda



[AWS Lambda](https://aws.amazon.com/lambda/) is a serverless compute service that lets you run code without provisioning or managing servers.

In this guide, we will deploy a Bun HTTP server to AWS Lambda using a `Dockerfile`.

<Note>
  Before continuing, make sure you have:

  * A Bun application ready for deployment
  * An [AWS account](https://aws.amazon.com/)
  * [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html) installed and configured
  * [Docker](https://docs.docker.com/get-started/get-docker/) installed and added to your `PATH`
</Note>

***

<Steps>
  <Step title="Create a new Dockerfile">
    Make sure you're in the directory containing your project, then create a new `Dockerfile` in the root of your project. This file contains the instructions to initialize the container, copy your local project files into it, install dependencies, and start the application.

    ```docker Dockerfile icon="docker" theme={"theme":{"light":"github-light","dark":"dracula"}}
    # Use the official AWS Lambda adapter image to handle the Lambda runtime
    FROM public.ecr.aws/awsguru/aws-lambda-adapter:0.9.0 AS aws-lambda-adapter

    # Use the official Bun image to run the application
    FROM oven/bun:debian AS bun_latest

    # Copy the Lambda adapter into the container
    COPY --from=aws-lambda-adapter /lambda-adapter /opt/extensions/lambda-adapter

    # Set the port to 8080. This is required for the AWS Lambda adapter.
    ENV PORT=8080

    # Set the work directory to `/var/task`. This is the default work directory for Lambda.
    WORKDIR "/var/task"

    # Copy the package.json and bun.lock into the container
    COPY package.json bun.lock ./

    # Install the dependencies
    RUN bun install --production --frozen-lockfile

    # Copy the rest of the application into the container
    COPY . /var/task

    # Run the application.
    CMD ["bun", "index.ts"]
    ```

    <Note>
      Make sure that the start command corresponds to your application's entry point. This can also be `CMD ["bun", "run", "start"]` if you have a start script in your `package.json`.

      This image installs dependencies and runs your app with Bun inside a container. If your app doesn't have dependencies, you can omit the `RUN bun install --production --frozen-lockfile` line.
    </Note>

    Create a new `.dockerignore` file in the root of your project. This file contains the files and directories that should be *excluded* from the container image, such as `node_modules`. This makes your builds faster and smaller:

    ```docker .dockerignore icon="Docker" theme={"theme":{"light":"github-light","dark":"dracula"}}
    node_modules
    Dockerfile*
    .dockerignore
    .git
    .gitignore
    README.md
    LICENSE
    .vscode
    .env
    # Any other files or directories you want to exclude
    ```
  </Step>

  <Step title="Build the Docker image">
    Make sure you're in the directory containing your `Dockerfile`, then build the Docker image. In this case, we'll call the image `bun-lambda-demo` and tag it as `latest`.

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    # cd /path/to/your/app
    docker build --provenance=false --platform linux/amd64 -t bun-lambda-demo:latest .
    ```
  </Step>

  <Step title="Create an ECR repository">
    To push the image to AWS Lambda, we first need to create an [ECR repository](https://aws.amazon.com/ecr/) to push the image to.

    By running the following command, we:

    * Create an ECR repository named `bun-lambda-demo` in the `us-east-1` region
    * Get the repository URI, and export the repository URI as an environment variable. This is optional, but make the next steps easier.

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    export ECR_URI=$(aws ecr create-repository --repository-name bun-lambda-demo --region us-east-1 --query 'repository.repositoryUri' --output text)
    echo $ECR_URI
    ```

    ```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
    [id].dkr.ecr.us-east-1.amazonaws.com/bun-lambda-demo
    ```

    <Note>
      If you're using IAM Identity Center (SSO) or have configured AWS CLI with profiles, you'll need to add the `--profile` flag to your AWS CLI commands.

      For example, if your profile is named `my-sso-app`, use `--profile my-sso-app`. Check your AWS CLI configuration with `aws configure list-profiles` to see available profiles.

      ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
      export ECR_URI=$(aws ecr create-repository --repository-name bun-lambda-demo --region us-east-1 --profile my-sso-app --query 'repository.repositoryUri' --output text)
      echo $ECR_URI
      ```
    </Note>
  </Step>

  <Step title="Authenticate with the ECR repository">
    Log in to the ECR repository:

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_URI
    ```

    ```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
    Login Succeeded
    ```

    <Note>
      If using a profile, use the `--profile` flag:

      ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
      aws ecr get-login-password --region us-east-1 --profile my-sso-app | docker login --username AWS --password-stdin $ECR_URI
      ```
    </Note>
  </Step>

  <Step title="Tag and push the docker image to the ECR repository">
    Make sure you're in the directory containing your `Dockerfile`, then tag the docker image with the ECR repository URI.

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    docker tag bun-lambda-demo:latest ${ECR_URI}:latest
    ```

    Then, push the image to the ECR repository.

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    docker push ${ECR_URI}:latest
    ```
  </Step>

  <Step title="Create an AWS Lambda function">
    Go to **AWS Console** > **Lambda** > [**Create Function**](https://us-east-1.console.aws.amazon.com/lambda/home?region=us-east-1#/create/function?intent=authorFromImage) > Select **Container image**

    <Warning>Make sure you've selected the right region, this URL defaults to `us-east-1`.</Warning>

    <Frame>
      <img alt="Create Function" />
    </Frame>

    Give the function a name, like `my-bun-function`.
  </Step>

  <Step title="Select the container image">
    Then, go to the **Container image URI** section, click on **Browse images**. Select the image we just pushed to the ECR repository.

    <Frame>
      <img alt="Select Container Repository" />
    </Frame>

    Then, select the `latest` image, and click on **Select image**.

    <Frame>
      <img alt="Select Container Image" />
    </Frame>
  </Step>

  <Step title="Configure the function">
    To get a public URL for the function, we need to go to **Additional configurations** > **Networking** > **Function URL**.

    Set this to **Enable**, with Auth Type **NONE**.

    <Frame>
      <img alt="Set the Function URL" />
    </Frame>
  </Step>

  <Step title="Create the function">
    Click on **Create function** at the bottom of the page, this will create the function.

    <Frame>
      <img alt="Create Function" />
    </Frame>
  </Step>

  <Step title="Get the function URL">
    Once the function has been created you'll be redirected to the function's page, where you can see the function URL in the **"Function URL"** section.

    <Frame>
      <img alt="Function URL" />
    </Frame>
  </Step>

  <Step title="Test the function">
    🥳 Your app is now live! To test the function, you can either go to the **Test** tab, or call the function URL directly.

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    curl -X GET https://[your-function-id].lambda-url.us-east-1.on.aws/
    ```

    ```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
    Hello from Bun on Lambda!
    ```
  </Step>
</Steps>


# Deploy a Bun application on DigitalOcean
Source: https://bun.com/docs/guides/deployment/digital-ocean



[DigitalOcean](https://www.digitalocean.com/) is a cloud platform that provides a range of services for building and deploying applications.

In this guide, we will deploy a Bun HTTP server to DigitalOcean using a `Dockerfile`.

<Note>
  Before continuing, make sure you have:

  * A Bun application ready for deployment
  * A [DigitalOcean account](https://www.digitalocean.com/)
  * [DigitalOcean CLI](https://docs.digitalocean.com/reference/doctl/how-to/install/#step-1-install-doctl) installed and configured
  * [Docker](https://docs.docker.com/get-started/get-docker/) installed and added to your `PATH`
</Note>

***

<Steps>
  <Step title="Create a new DigitalOcean Container Registry">
    Create a new Container Registry to store the Docker image.

    <Tabs>
      <Tab title="Through the DigitalOcean dashboard">
        In the DigitalOcean dashboard, go to [**Container Registry**](https://cloud.digitalocean.com/registry), and enter the details for the new registry.

        <Frame>
          <img alt="DigitalOcean registry dashboard" />
        </Frame>

        Make sure the details are correct, then click **Create Registry**.
      </Tab>

      <Tab title="Through the DigitalOcean CLI">
        ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
        doctl registry create bun-digitalocean-demo
        ```

        ```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
        Name                     Endpoint                                           Region slug
        bun-digitalocean-demo    registry.digitalocean.com/bun-digitalocean-demo    sfo2
        ```
      </Tab>
    </Tabs>

    You should see the new registry in the [**DigitalOcean registry dashboard**](https://cloud.digitalocean.com/registry):

    <Frame>
      <img alt="DigitalOcean registry dashboard" />
    </Frame>
  </Step>

  <Step title="Create a new Dockerfile">
    Make sure you're in the directory containing your project, then create a new `Dockerfile` in the root of your project. This file contains the instructions to initialize the container, copy your local project files into it, install dependencies, and start the application.

    ```docker Dockerfile icon="docker" theme={"theme":{"light":"github-light","dark":"dracula"}}
    # Use the official Bun image to run the application
    FROM oven/bun:debian

    # Set the work directory to `/app`
    WORKDIR /app

    # Copy the package.json and bun.lock into the container
    COPY package.json bun.lock ./

    # Install the dependencies
    RUN bun install --production --frozen-lockfile

    # Copy the rest of the application into the container
    COPY . .

    # Expose the port (DigitalOcean will set PORT env var)
    EXPOSE 8080

    # Run the application
    CMD ["bun", "index.ts"]
    ```

    <Note>
      Make sure that the start command corresponds to your application's entry point. This can also be `CMD ["bun", "run", "start"]` if you have a start script in your `package.json`.

      This image installs dependencies and runs your app with Bun inside a container. If your app doesn't have dependencies, you can omit the `RUN bun install --production --frozen-lockfile` line.
    </Note>

    Create a new `.dockerignore` file in the root of your project. This file contains the files and directories that should be *excluded* from the container image, such as `node_modules`. This makes your builds faster and smaller:

    ```docker .dockerignore icon="Docker" theme={"theme":{"light":"github-light","dark":"dracula"}}
    node_modules
    Dockerfile*
    .dockerignore
    .git
    .gitignore
    README.md
    LICENSE
    .vscode
    .env
    # Any other files or directories you want to exclude
    ```
  </Step>

  <Step title="Authenticate Docker with DigitalOcean registry">
    Before building and pushing the Docker image, authenticate Docker with the DigitalOcean Container Registry:

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    doctl registry login
    ```

    ```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
    Successfully authenticated with registry.digitalocean.com
    ```

    <Note>
      This command authenticates Docker with DigitalOcean's registry using your DigitalOcean credentials. Without this step, the build and push command will fail with a 401 authentication error.
    </Note>
  </Step>

  <Step title="Build and push the Docker image to the DigitalOcean registry">
    Make sure you're in the directory containing your `Dockerfile`, then build and push the Docker image to the DigitalOcean registry in one command:

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    docker buildx build --platform=linux/amd64 -t registry.digitalocean.com/bun-digitalocean-demo/bun-digitalocean-demo:latest --push .
    ```

    <Note>
      If you're building on an ARM Mac (M1/M2), you must use `docker buildx` with `--platform=linux/amd64` to ensure compatibility with DigitalOcean's infrastructure. Using `docker build` without the platform flag will create an ARM64 image that won't run on DigitalOcean.
    </Note>

    Once the image is pushed, you should see it in the [**DigitalOcean registry dashboard**](https://cloud.digitalocean.com/registry):

    <Frame>
      <img alt="DigitalOcean registry dashboard" />
    </Frame>
  </Step>

  <Step title="Create a new DigitalOcean App Platform project">
    In the DigitalOcean dashboard, go to [**App Platform**](https://cloud.digitalocean.com/apps) > **Create App**. We can create a project directly from the container image.

    <Frame>
      <img alt="DigitalOcean App Platform project dashboard" />
    </Frame>

    Make sure the details are correct, then click **Next**.

    <Frame>
      <img alt="DigitalOcean App Platform service dashboard" />
    </Frame>

    Review and configure resource settings, then click **Create app**.

    <Frame>
      <img alt="DigitalOcean App Platform service dashboard" />
    </Frame>
  </Step>

  <Step title="Visit your live application">
    🥳 Your app is now live! Once the app is created, you should see it in the App Platform dashboard with the public URL.

    <Frame>
      <img alt="DigitalOcean App Platform app dashboard" />
    </Frame>
  </Step>
</Steps>


# Deploy a Bun application on Google Cloud Run
Source: https://bun.com/docs/guides/deployment/google-cloud-run



[Google Cloud Run](https://cloud.google.com/run) is a managed platform for deploying and scaling serverless applications. Google handles the infrastructure for you.

In this guide, we will deploy a Bun HTTP server to Google Cloud Run using a `Dockerfile`.

<Note>
  Before continuing, make sure you have:

  * A Bun application ready for deployment
  * A [Google Cloud account](https://cloud.google.com/) with billing enabled
  * [Google Cloud CLI](https://cloud.google.com/sdk/docs/install) installed and configured
</Note>

***

<Steps>
  <Step title={<span>Initialize <code>gcloud</code> by select/creating a project</span>}>
    Make sure that you've initialized the Google Cloud CLI. This command logs you in, and prompts you to either select an existing project or create a new one.

    For more help with the Google Cloud CLI, see the [official documentation](https://docs.cloud.google.com/sdk/gcloud/reference/init).

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    gcloud init
    ```

    ```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
    Welcome! This command will take you through the configuration of gcloud.

    You must sign in to continue. Would you like to sign in (Y/n)? Y
    You are signed in as [email@example.com].

    Pick cloud project to use:
     [1] existing-bun-app-1234
     [2] Enter a project ID
     [3] Create a new project
    Please enter numeric choice or text value (must exactly match list item): 3

    Enter a Project ID. my-bun-app
    Your current project has been set to: [my-bun-app]

    The Google Cloud CLI is configured and ready to use!
    ```
  </Step>

  <Step title="(Optional) Store your project info in environment variables">
    Set variables for your project ID and number so they're easier to reuse in the following steps.

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    PROJECT_ID=$(gcloud projects list --format='value(projectId)' --filter='name="my bun app"')
    PROJECT_NUMBER=$(gcloud projects list --format='value(projectNumber)' --filter='name="my bun app"')

    echo $PROJECT_ID $PROJECT_NUMBER
    ```

    ```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
    my-bun-app-... [PROJECT_NUMBER]
    ```
  </Step>

  <Step title="Link a billing account">
    List your available billing accounts and link one to your project:

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    gcloud billing accounts list
    ```

    ```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
    ACCOUNT_ID            NAME                OPEN  MASTER_ACCOUNT_ID
    [BILLING_ACCOUNT_ID]  My Billing Account  True
    ```

    Link your billing account to your project. Replace `[BILLING_ACCOUNT_ID]` with the ID of your billing account.

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    gcloud billing projects link $PROJECT_ID --billing-account=[BILLING_ACCOUNT_ID]
    ```

    ```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
    billingAccountName: billingAccounts/[BILLING_ACCOUNT_ID]
    billingEnabled: true
    name: projects/my-bun-app-.../billingInfo
    projectId: my-bun-app-...
    ```
  </Step>

  <Step title="Enable APIs and configure IAM roles">
    Activate the necessary services and grant Cloud Build permissions:

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    gcloud services enable run.googleapis.com cloudbuild.googleapis.com
    gcloud projects add-iam-policy-binding $PROJECT_ID \
      --member=serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com \
      --role=roles/run.builder
    ```

    <Note>
      These commands enable Cloud Run (`run.googleapis.com`) and Cloud Build (`cloudbuild.googleapis.com`), which are required for deploying from source. Cloud Run runs your containerized app, while Cloud Build handles building and packaging it.

      The IAM binding grants the Compute Engine service account (`$PROJECT_NUMBER-compute@developer.gserviceaccount.com`) permission to build and deploy images on your behalf.
    </Note>
  </Step>

  <Step title="Add a Dockerfile">
    Create a new `Dockerfile` in the root of your project. This file contains the instructions to initialize the container, copy your local project files into it, install dependencies, and start the application.

    ```docker Dockerfile icon="docker" theme={"theme":{"light":"github-light","dark":"dracula"}}
    # Use the official Bun image to run the application
    FROM oven/bun:latest

    # Copy the package.json and bun.lock into the container
    COPY package.json bun.lock ./

    # Install the dependencies
    # Install the dependencies
    RUN bun install --production --frozen-lockfile

    # Copy the rest of the application into the container
    COPY . .

    # Run the application
    CMD ["bun", "index.ts"]
    ```

    <Note>
      Make sure that the start command corresponds to your application's entry point. This can also be `CMD ["bun", "run", "start"]` if you have a start script in your `package.json`.

      This image installs dependencies and runs your app with Bun inside a container. If your app doesn't have dependencies, you can omit the `RUN bun install --production --frozen-lockfile` line.
    </Note>

    Create a new `.dockerignore` file in the root of your project. This file contains the files and directories that should be *excluded* from the container image, such as `node_modules`. This makes your builds faster and smaller:

    ```docker .dockerignore icon="Docker" theme={"theme":{"light":"github-light","dark":"dracula"}}
    node_modules
    Dockerfile*
    .dockerignore
    .git
    .gitignore
    README.md
    LICENSE
    .vscode
    .env
    # Any other files or directories you want to exclude
    ```
  </Step>

  <Step title="Deploy your service">
    Make sure you're in the directory containing your `Dockerfile`, then deploy directly from your local source:

    <Note>
      Update the `--region` flag to your preferred region. You can also omit this flag to get an interactive prompt to
      select a region.
    </Note>

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    gcloud run deploy my-bun-app --source . --region=us-west1 --allow-unauthenticated
    ```

    ```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
    Deploying from source requires an Artifact Registry Docker repository to store built containers. A repository named
    [cloud-run-source-deploy] in region [us-west1] will be created.

    Do you want to continue (Y/n)? Y

    Building using Dockerfile and deploying container to Cloud Run service [my-bun-app] in project [my-bun-app-...] region [us-west1]
    ✓ Building and deploying... Done.
      ✓ Validating Service...
      ✓ Uploading sources...
      ✓ Building Container... Logs are available at [https://console.cloud.google.com/cloud-build/builds...].
      ✓ Creating Revision...
      ✓ Routing traffic...
      ✓ Setting IAM Policy...
    Done.
    Service [my-bun-app] revision [my-bun-app-...] has been deployed and is serving 100 percent of traffic.
    Service URL: https://my-bun-app-....us-west1.run.app
    ```
  </Step>

  <Step title="Visit your live application">
    🎉 Your Bun application is now live!

    Visit the Service URL (`https://my-bun-app-....us-west1.run.app`) to confirm everything works as expected.
  </Step>
</Steps>


# Deploy a Bun application on Railway
Source: https://bun.com/docs/guides/deployment/railway

Deploy Bun applications to Railway with this step-by-step guide covering CLI and dashboard methods, optional PostgreSQL setup, and automatic SSL configuration.

Railway is an infrastructure platform where you can provision infrastructure, develop with that infrastructure locally, and then deploy to the cloud. It enables instant deployments from GitHub with zero configuration, automatic SSL, and built-in database provisioning.

This guide walks through deploying a Bun application with a PostgreSQL database (optional), which is exactly what the template below provides.

You can either follow this guide step-by-step or simply deploy the pre-configured template with one click:

<a href="https://railway.com/deploy/bun-react-postgres?referralCode=Bun&utm_medium=integration&utm_source=template&utm_campaign=bun">
  <img alt="Deploy on Railway" />
</a>

***

**Prerequisites**:

* A Bun application ready for deployment
* A [Railway account](https://railway.app/)
* Railway CLI (for CLI deployment method)
* A GitHub account (for Dashboard deployment method)

***

## Method 1: Deploy via CLI

<Steps>
  <Step title="Step 1">
    Ensure sure you have the Railway CLI installed.

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    bun install -g @railway/cli
    ```
  </Step>

  <Step title="Step 2">
    Log into your Railway account.

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    railway login
    ```
  </Step>

  <Step title="Step 3">
    After successfully authenticating, initialize a new project.

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    railway init
    ```
  </Step>

  <Step title="Step 4">
    After initializing the project, add a new database and service.

    <Note>Step 4 is only necessary if your application uses a database. If you don't need PostgreSQL, skip to Step 5.</Note>

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    # Add PostgreSQL database. Make sure to add this first!
    railway add --database postgres

    # Add your application service.
    railway add --service bun-react-db --variables DATABASE_URL=\${{Postgres.DATABASE_URL}}
    ```
  </Step>

  <Step title="Step 5">
    After the services have been created and connected, deploy the application to Railway. By default, services are only accessible within Railway's private network. To make your app publicly accessible, you need to generate a public domain.

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    # Deploy your application
    railway up

    # Generate public domain
    railway domain
    ```
  </Step>
</Steps>

Your app is now live! Railway auto-deploys on every GitHub push.

***

## Method 2: Deploy via Dashboard

<Steps>
  <Step title="Step 1">
    Create a new project

    1. Go to [Railway Dashboard](http://railway.com/dashboard?utm_medium=integration\&utm_source=docs\&utm_campaign=bun)
    2. Click **"+ New"** → **"GitHub repo"**
    3. Choose your repository
  </Step>

  <Step title="Step 2">
    Add a PostgreSQL database, and connect this database to the service

    <Note>Step 2 is only necessary if your application uses a database. If you don't need PostgreSQL, skip to Step 3.</Note>

    1. Click **"+ New"** → **"Database"** → **"Add PostgreSQL"**
    2. After the database has been created, select your service (not the database)
    3. Go to **"Variables"** tab
    4. Click **"+ New Variable"** → **"Add Reference"**
    5. Select `DATABASE_URL` from postgres
  </Step>

  <Step title="Step 3">
    Generate a public domain

    1. Select your service
    2. Go to **"Settings"** tab
    3. Under **"Networking"**, click **"Generate Domain"**
  </Step>
</Steps>

Your app is now live! Railway auto-deploys on every GitHub push.

***

## Configuration (Optional)

By default, Railway uses [Nixpacks](https://docs.railway.com/guides/build-configuration#nixpacks-options) to automatically detect and build your Bun application with zero configuration.

However, using the [Railpack](https://docs.railway.com/guides/build-configuration#railpack) application builder provides better Bun support, and will always support the latest version of Bun. The pre-configured templates use Railpack by default.

To enable Railpack in a custom project, add the following to your `railway.json`:

```json railway.json icon="file-json" theme={"theme":{"light":"github-light","dark":"dracula"}}
{
  "$schema": "https://railway.com/railway.schema.json",
  "build": {
    "builder": "RAILPACK"
  }
}
```

For more build configuration settings, check out the [Railway documentation](https://docs.railway.com/guides/build-configuration).


# Deploy a Bun application on Render
Source: https://bun.com/docs/guides/deployment/render



[Render](https://render.com/) is a cloud platform that lets you flexibly build, deploy, and scale your apps.

It offers features like auto deploys from GitHub, a global CDN, private networks, automatic HTTPS setup, and managed PostgreSQL and Redis.

Render supports Bun natively. You can deploy Bun apps as web services, background workers, cron jobs, and more.

***

As an example, let's deploy a simple Express HTTP server to Render.

<Steps>
  <Step title="Step 1">
    Create a new GitHub repo named `myapp`. Git clone it locally.

    ```sh theme={"theme":{"light":"github-light","dark":"dracula"}}
    git clone git@github.com:my-github-username/myapp.git
    cd myapp
    ```
  </Step>

  <Step title="Step 2">
    Add the Express library.

    ```sh theme={"theme":{"light":"github-light","dark":"dracula"}}
    bun add express
    ```
  </Step>

  <Step title="Step 3">
    Define a simple server with Express:

    ```ts app.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
    import express from "express";

    const app = express();
    const port = process.env.PORT || 3001;

    app.get("/", (req, res) => {
    	res.send("Hello World!");
    });

    app.listen(port, () => {
    	console.log(`Listening on port ${port}...`);
    });
    ```
  </Step>

  <Step title="Step 4">
    Commit your changes and push to GitHub.

    ```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    git add app.ts bun.lock package.json
    git commit -m "Create simple Express app"
    git push origin main
    ```
  </Step>

  <Step title="Step 5">
    In your [Render Dashboard](https://dashboard.render.com/), click `New` > `Web Service` and connect your `myapp` repo.
  </Step>

  <Step title="Step 6">
    In the Render UI, provide the following values during web service creation:

    |                   |               |
    | ----------------- | ------------- |
    | **Runtime**       | `Node`        |
    | **Build Command** | `bun install` |
    | **Start Command** | `bun app.ts`  |
  </Step>
</Steps>

That's it! Your web service will be live at its assigned `onrender.com` URL as soon as the build finishes.

You can view the [deploy logs](https://docs.render.com/logging#logs-for-an-individual-deploy-or-job) for details. Refer to [Render's documentation](https://docs.render.com/deploys) for a complete overview of deploying on Render.


# Deploy a Bun application on Vercel
Source: https://bun.com/docs/guides/deployment/vercel



[Vercel](https://vercel.com/) is a cloud platform that lets you build, deploy, and scale your apps.

<Warning>
  The Bun runtime is in Beta; certain features (e.g., automatic source maps, byte-code caching, metrics on
  `node:http/https`) are not yet supported.
</Warning>

<Note>
  `Bun.serve` is currently not supported on Vercel Functions. Use Bun with frameworks supported by Vercel, like Next.js,
  Express, Hono, or Nitro.
</Note>

***

<Steps>
  <Step title="Configure Bun in vercel.json">
    To enable the Bun runtime for your Functions, add a `bunVersion` field in your `vercel.json` file:

    ```json vercel.json icon="file-json" theme={"theme":{"light":"github-light","dark":"dracula"}}
    {
    	"bunVersion": "1.x" // [!code ++]
    }
    ```

    Vercel automatically detects this configuration and runs your application on Bun. The value has to be `"1.x"`, Vercel handles the minor version internally.

    For best results, match your local Bun version with the version used by Vercel.
  </Step>

  <Step title="Next.js configuration">
    If you’re deploying a **Next.js** project (including ISR), update your `package.json` scripts to use the Bun runtime:

    ```json package.json icon="file-json" theme={"theme":{"light":"github-light","dark":"dracula"}}
    {
    	"scripts": {
    		"dev": "bun --bun next dev", // [!code ++]
    		"build": "bun --bun next build" // [!code ++]
    	}
    }
    ```

    <Note>
      The `--bun` flag runs the Next.js CLI under Bun. Bundling (via Turbopack or Webpack) remains unchanged, but all commands execute within the Bun runtime.
    </Note>

    This ensures both local development and builds use Bun.
  </Step>

  <Step title="Deploy your app">
    Connect your repository to Vercel, or deploy from the CLI:

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    # Using bunx (no global install)
    bunx vercel login
    bunx vercel deploy
    ```

    Or install the Vercel CLI globally:

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    bun i -g vercel
    vercel login
    vercel deploy
    ```

    [Learn more in the Vercel Deploy CLI documentation →](https://vercel.com/docs/cli/deploy)
  </Step>

  <Step title="Verify the runtime">
    To confirm your deployment uses Bun, log the Bun version:

    ```ts index.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
    console.log("runtime", process.versions.bun);
    ```

    ```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
    runtime 1.3.3
    ```

    [See the Vercel Bun Runtime documentation for feature support →](https://vercel.com/docs/functions/runtimes/bun#feature-support)
  </Step>
</Steps>

***

* [Fluid compute](https://vercel.com/docs/fluid-compute): Both Bun and Node.js runtimes run on Fluid compute and support the same core Vercel Functions features.
* [Middleware](https://vercel.com/docs/routing-middleware): To run Routing Middleware with Bun, set the runtime to `nodejs`:

```ts middleware.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
export const config = { runtime: "nodejs" }; // [!code ++]
```


# Run Bun as a daemon with PM2
Source: https://bun.com/docs/guides/ecosystem/pm2



[PM2](https://pm2.keymetrics.io/) is a popular process manager that manages and runs your applications as daemons (background processes).

It offers features like process monitoring, automatic restarts, and easy scaling. Using a process manager is common when deploying a Bun application on a cloud-hosted virtual private server (VPS), as it:

* Keeps your Node.js application running continuously.
* Ensure high availability and reliability of your application.
* Monitor and manage multiple processes with ease.
* Simplify the deployment process.

***

You can use PM2 with Bun in two ways: as a CLI option or in a configuration file.

### With `--interpreter`

To start your application with PM2 and Bun as the interpreter, open your terminal and run the following command:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
pm2 start --interpreter ~/.bun/bin/bun index.ts
```

***

### With a configuration file

Alternatively, you can create a PM2 configuration file. Create a file named `pm2.config.js` in your project directory and add the following content.

```js pm2.config.js icon="file-code" theme={"theme":{"light":"github-light","dark":"dracula"}}
module.exports = {
  name: "app", // Name of your application
  script: "index.ts", // Entry point of your application
  interpreter: "bun", // Bun interpreter
  env: {
    PATH: `${process.env.HOME}/.bun/bin:${process.env.PATH}`, // Add "~/.bun/bin/bun" to PATH
  },
};
```

***

After saving the file, you can start your application with PM2

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
pm2 start pm2.config.js
```

***

That’s it! Your JavaScript/TypeScript web server is now running as a daemon with PM2 using Bun as the interpreter.


# Use Prisma with Bun
Source: https://bun.com/docs/guides/ecosystem/prisma



<Note>
  **Note** — Prisma's dynamic subcommand loading system currently requires npm to be installed alongside Bun. This
  affects certain CLI commands like `prisma init`, `prisma migrate`, etc. Generated code works perfectly with Bun using
  the new `prisma-client` generator.
</Note>

<Steps>
  <Step title="Create a new project">
    Prisma works out of the box with Bun. First, create a directory and initialize it with `bun init`.

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    mkdir prisma-app
    cd prisma-app
    bun init
    ```
  </Step>

  <Step title="Install Prisma dependencies">
    Then install the Prisma CLI (`prisma`), Prisma Client (`@prisma/client`), and the LibSQL adapter as dependencies.

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    bun add -d prisma
    bun add @prisma/client @prisma/adapter-libsql
    ```
  </Step>

  <Step title="Initialize Prisma with SQLite">
    We'll use the Prisma CLI with `bunx` to initialize our schema and migration directory. For simplicity we'll be using an in-memory SQLite database.

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    bunx --bun prisma init --datasource-provider sqlite
    ```

    This creates a basic schema. We need to update it to use the new Rust-free client with Bun optimization. Open `prisma/schema.prisma` and modify the generator block, then add a simple `User` model.

    ```prisma prisma/schema.prisma icon="https://mintcdn.com/bun-1dd33a4e/ztkOKlOzC-ndb59O/icons/ecosystem/prisma.svg?fit=max&auto=format&n=ztkOKlOzC-ndb59O&q=85&s=e11053a2c03cc3eb38539358a21b28c9" theme={"theme":{"light":"github-light","dark":"dracula"}}
      generator client {
        provider = "prisma-client" // [!code ++]
        output = "./generated" // [!code ++]
        engineType = "client" // [!code ++]
        runtime = "bun" // [!code ++]
      }

      datasource db {
        provider = "sqlite"
        url      = env("DATABASE_URL")
      }

      model User { // [!code ++]
        id    Int     @id @default(autoincrement()) // [!code ++]
        email String  @unique // [!code ++]
        name  String? // [!code ++]
      } // [!code ++]
    ```
  </Step>

  <Step title="Create and run database migration">
    Then generate and run initial migration.

    This will generate a `.sql` migration file in `prisma/migrations`, create a new SQLite instance, and execute the migration against the new instance.

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
     bunx --bun prisma migrate dev --name init
    ```

    ```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
    Environment variables loaded from .env
    Prisma schema loaded from prisma/schema.prisma
    Datasource "db": SQLite database "dev.db" at "file:./dev.db"

    SQLite database dev.db created at file:./dev.db

    Applying migration `20251014141233_init`

    The following migration(s) have been created and applied from new schema changes:

    prisma/migrations/
     └─ 20251014141233_init/
       └─ migration.sql

    Your database is now in sync with your schema.

    ✔ Generated Prisma Client (6.17.1) to ./generated in 18ms
    ```
  </Step>

  <Step title="Generate Prisma Client">
    As indicated in the output, Prisma re-generates our *Prisma client* whenever we execute a new migration. The client provides a fully typed API for reading and writing from our database. You can manually re-generate the client with the Prisma CLI.

    ```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    bunx --bun prisma generate
    ```
  </Step>

  <Step title="Initialize Prisma Client with LibSQL">
    Now we need to create a Prisma client instance. Create a new file `prisma/db.ts` to initialize the PrismaClient with the LibSQL adapter.

    ```ts prisma/db.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
    import { PrismaClient } from "./generated/client";
    import { PrismaLibSQL } from "@prisma/adapter-libsql";

    const adapter = new PrismaLibSQL({ url: process.env.DATABASE_URL || "" });
    export const prisma = new PrismaClient({ adapter });
    ```
  </Step>

  <Step title="Create a test script">
    Let's write a simple script to create a new user, then count the number of users in the database.

    ```ts index.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
    import { prisma } from "./prisma/db";

    // create a new user
    await prisma.user.create({
      data: {
        name: "John Dough",
        email: `john-${Math.random()}@example.com`,
      },
    });

    // count the number of users
    const count = await prisma.user.count();
    console.log(`There are ${count} users in the database.`);
    ```
  </Step>

  <Step title="Run and test the application">
    Let's run this script with `bun run`. Each time we run it, a new user is created.

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    bun run index.ts
    ```

    ```txg theme={"theme":{"light":"github-light","dark":"dracula"}}
    Created john-0.12802932895402364@example.com
    There are 1 users in the database.
    ```

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    bun run index.ts
    ```

    ```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
    Created john-0.8671308799782803@example.com
    There are 2 users in the database.
    ```

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    bun run index.ts
    ```

    ```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
    Created john-0.4465968383115295@example.com
    There are 3 users in the database.
    ```
  </Step>
</Steps>

***

That's it! Now that you've set up Prisma using Bun, we recommend referring to the [official Prisma docs](https://www.prisma.io/docs/orm/prisma-client) as you continue to develop your application.


# Use Prisma Postgres with Bun
Source: https://bun.com/docs/guides/ecosystem/prisma-postgres



<Note>
  **Note** — At the moment Prisma needs Node.js to be installed to run certain generation code. Make sure Node.js is
  installed in the environment where you're running `bunx prisma` commands.
</Note>

<Steps>
  <Step title="Create a new project">
    First, create a directory and initialize it with `bun init`.

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    mkdir prisma-postgres-app
    cd prisma-postgres-app
    bun init
    ```
  </Step>

  <Step title="Install Prisma dependencies">
    Then install the Prisma CLI (`prisma`), Prisma Client (`@prisma/client`), and the accelerate extension as dependencies.

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    bun add -d prisma
    bun add @prisma/client @prisma/extension-accelerate
    ```
  </Step>

  <Step title="Initialize Prisma with PostgreSQL">
    We'll use the Prisma CLI with `bunx` to initialize our schema and migration directory. We'll be using PostgreSQL as our database.

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    bunx --bun prisma init --db
    ```

    This creates a basic schema. We need to update it to use the new Rust-free client with Bun optimization. Open `prisma/schema.prisma` and modify the generator block, then add a simple `User` model.

    ```prisma prisma/schema.prisma icon="https://mintcdn.com/bun-1dd33a4e/ztkOKlOzC-ndb59O/icons/ecosystem/prisma.svg?fit=max&auto=format&n=ztkOKlOzC-ndb59O&q=85&s=e11053a2c03cc3eb38539358a21b28c9" theme={"theme":{"light":"github-light","dark":"dracula"}}
    generator client {
    	provider = "prisma-client"
    	output = "./generated" // [!code ++]
    	engineType = "client" // [!code ++]
    	runtime = "bun" // [!code ++]
    }

    datasource db {
    	provider = "postgresql"
    	url      = env("DATABASE_URL")
    }

    model User { // [!code ++]
    	id    Int     @id @default(autoincrement()) // [!code ++]
    	email String  @unique // [!code ++]
    	name  String? // [!code ++]
    } // [!code ++]
    ```
  </Step>

  <Step title="Configure database connection">
    Set up your Postgres database URL in the `.env` file.

    ```ini .env icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
    DATABASE_URL="postgresql://username:password@localhost:5432/mydb?schema=public"
    ```
  </Step>

  <Step title="Create and run database migration">
    Then generate and run initial migration.

    This will generate a `.sql` migration file in `prisma/migrations`, and execute the migration against your Postgres database.

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    bunx --bun prisma migrate dev --name init
    ```

    ```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
    Environment variables loaded from .env
    Prisma schema loaded from prisma/schema.prisma
    Datasource "db": PostgreSQL database "mydb", schema "public" at "localhost:5432"

    Applying migration `20250114141233_init`

    The following migration(s) have been created and applied from new schema changes:

    prisma/migrations/
      └─ 20250114141233_init/
        └─ migration.sql

    Your database is now in sync with your schema.

    ✔ Generated Prisma Client (6.17.1) to ./generated in 18ms
    ```
  </Step>

  <Step title="Generate Prisma Client">
    As indicated in the output, Prisma re-generates our *Prisma client* whenever we execute a new migration. The client provides a fully typed API for reading and writing from our database. You can manually re-generate the client with the Prisma CLI.

    ```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    bunx --bun prisma generate
    ```
  </Step>

  <Step title="Initialize Prisma Client with Accelerate">
    Now we need to create a Prisma client instance. Create a new file `prisma/db.ts` to initialize the PrismaClient with the Postgres adapter.

    ```ts prisma/db.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
    import { PrismaClient } from "./generated/client";
    import { withAccelerate } from '@prisma/extension-accelerate'

    export const prisma = new PrismaClient().$extends(withAccelerate())
    ```
  </Step>

  <Step title="Create a test script">
    Let's write a simple script to create a new user, then count the number of users in the database.

    ```ts index.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
    import { prisma } from "./prisma/db";

    // create a new user
    await prisma.user.create({
      data: {
        name: "John Dough",
        email: `john-${Math.random()}@example.com`,
      },
    });

    // count the number of users
    const count = await prisma.user.count();
    console.log(`There are ${count} users in the database.`);
    ```
  </Step>

  <Step title="Run and test the application">
    Let's run this script with `bun run`. Each time we run it, a new user is created.

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    bun run index.ts
    ```

    ```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
    There are 1 users in the database.
    ```

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    bun run index.ts
    ```

    ```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
    There are 2 users in the database.
    ```

    ```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    bun run index.ts
    ```

    ```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
    There are 3 users in the database.
    ```
  </Step>
</Steps>

***

That's it! Now that you've set up Prisma Postgres using Bun, we recommend referring to the [official Prisma Postgres docs](https://www.prisma.io/docs/postgres) as you continue to develop your application.


# Build an app with Qwik and Bun
Source: https://bun.com/docs/guides/ecosystem/qwik



Initialize a new Qwik app with `bunx create-qwik`.

The `create-qwik` package detects when you are using `bunx` and will automatically install dependencies using `bun`.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun create qwik
```

```txts theme={"theme":{"light":"github-light","dark":"dracula"}}
      ............
    .::: :--------:.
   .::::  .:-------:.
  .:::::.   .:-------.
  ::::::.     .:------.
 ::::::.        :-----:
 ::::::.       .:-----.
  :::::::.     .-----.
   ::::::::..   ---:.
    .:::::::::. :-:.
     ..::::::::::::
             ...::::


┌  Let's create a  Qwik App  ✨ (v1.2.10)
│
◇  Where would you like to create your new project? (Use '.' or './' for current directory)
│  ./my-app
│
●  Creating new project in  /path/to/my-app  ... 🐇
│
◇  Select a starter
│  Basic App
│
◇  Would you like to install bun dependencies?
│  Yes
│
◇  Initialize a new git repository?
│  No
│
◇  Finishing the install. Wanna hear a joke?
│  Yes
│
○  ────────────────────────────────────────────────────────╮
│                                                          │
│  How do you know if there’s an elephant under your bed?  │
│  Your head hits the ceiling!                             │
│                                                          │
├──────────────────────────────────────────────────────────╯
│
◇  App Created 🐰
│
◇  Installed bun dependencies 📋
│
○  Result ─────────────────────────────────────────────╮
│                                                      │
│  Success!  Project created in my-app directory       │
│                                                      │
│  Integrations? Add Netlify, Cloudflare, Tailwind...  │
│  bun qwik add                                        │
│                                                      │
│  Relevant docs:                                      │
│  https://qwik.dev/docs/getting-started/              │
│                                                      │
│  Questions? Start the conversation at:               │
│  https://qwik.dev/chat                               │
│  https://twitter.com/QwikDev                         │
│                                                      │
│  Presentations, Podcasts and Videos:                 │
│  https://qwik.dev/media/                             │
│                                                      │
│  Next steps:                                         │
│  cd my-app                                           │
│  bun start                                           │
│                                                      │
│                                                      │
├──────────────────────────────────────────────────────╯
│
└  Happy coding! 🎉

```

***

Run `bun run dev` to start the development server.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun run dev
```

```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
$ vite--mode ssr

VITE v4.4.7  ready in 1190 ms

➜  Local:   http://localhost:5173/
➜  Network: use --host to expose
➜  press h to show help
```

***

Open [http://localhost:5173](http://localhost:5173) with your browser to see the result. Qwik will hot-reload your app as you edit your source files.

<Frame>![Qwik screenshot](https://github.com/oven-sh/bun/assets/3084745/ec35f2f7-03dd-4c90-851e-fb4ad150bb28)</Frame>

***

Refer to the [Qwik docs](https://qwik.dev/docs/getting-started/) for complete documentation.


# Build a React app with Bun
Source: https://bun.com/docs/guides/ecosystem/react



Bun supports `.jsx` and `.tsx` files out of the box. React just works with Bun.

Create a new React app with `bun init --react`. This gives you a template with a simple React app and a simple API server together in one full-stack app.

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
# Create a new React app
bun init --react

# Run the app in development mode
bun dev

# Build as a static site for production
bun run build

# Run the server in production
bun start
```

***

### Hot Reloading

Run `bun dev` to start the app in development mode. This will start the API server and the React app with hot reloading.

### Full-Stack App

Run `bun start` to start the API server and frontend together in one process.

### Static Site

Run `bun run build` to build the app as a static site. This will create a `dist` directory with the built app and all the assets.

```txt File Tree icon="folder-tree" theme={"theme":{"light":"github-light","dark":"dracula"}}
├── src/
│   ├── index.tsx       # Server entry point with API routes
│   ├── frontend.tsx    # React app entry point with HMR
│   ├── App.tsx         # Main React component
│   ├── APITester.tsx   # Component for testing API endpoints
│   ├── index.html      # HTML template
│   ├── index.css       # Styles
│   └── *.svg           # Static assets
├── package.json        # Dependencies and scripts
├── tsconfig.json       # TypeScript configuration
├── bunfig.toml         # Bun configuration
└── bun.lock            # Lock file
```


# Build an app with Remix and Bun
Source: https://bun.com/docs/guides/ecosystem/remix



<Note>
  Currently the Remix development server (`remix dev`) relies on Node.js APIs that Bun does not yet implement. The guide
  below uses Bun to initialize a project and install dependencies, but it uses Node.js to run the dev server.
</Note>

***

Initialize a Remix app with `create-remix`.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun create remix
```

```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
 remix   v1.19.3 💿 Let's build a better website...

   dir   Where should we create your new project?
         ./my-app

      ◼  Using basic template See https://remix.run/docs/en/main/guides/templates#templates for more
      ✔  Template copied

   git   Initialize a new git repository?
         Yes

  deps   Install dependencies with bun?
         Yes

      ✔  Dependencies installed
      ✔  Git initialized

  done   That's it!
         Enter your project directory using cd ./my-app
         Check out README.md for development and deploy instructions.
```

***

To start the dev server, run `bun run dev` from the project root. This will start the dev server using the `remix dev` command. Note that Node.js will be used to run the dev server.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
cd my-app
bun run dev
```

```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
$ remix dev

💿  remix dev

info  building...
info  built (263ms)
Remix App Server started at http://localhost:3000 (http://172.20.0.143:3000)
```

***

Open [http://localhost:3000](http://localhost:3000) to see the app. Any changes you make to `app/routes/_index.tsx` will be hot-reloaded in the browser.

<Frame>
  ![Remix app running on localhost](https://github.com/oven-sh/bun/assets/3084745/c26f1059-a5d4-4c0b-9a88-d9902472fd77)
</Frame>

***

To build and start your app, run `bun run build`

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun run build
```

```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
$ remix build
info  building... (NODE_ENV=production)
info  built (158ms)
```

Then `bun run start` from the project root.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun start
```

```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
$ remix-serve ./build/index.js
[remix-serve] http://localhost:3000 (http://192.168.86.237:3000)
```

***

Read the [Remix docs](https://remix.run/) for more information on how to build apps with Remix.


# Add Sentry to a Bun app
Source: https://bun.com/docs/guides/ecosystem/sentry



[Sentry](https://sentry.io) is a developer-first error tracking and performance monitoring platform. Sentry has a first-class SDK for Bun, `@sentry/bun`, that instruments your Bun application to automatically collect error and performance data.

Don't already have an account and Sentry project established? Head over to [sentry.io](https://sentry.io/signup/), then return to this page.

***

To start using Sentry with Bun, first install the Sentry Bun SDK.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun add @sentry/bun
```

***

Then, initialize the Sentry SDK with your Sentry DSN in your app's entry file. You can find your DSN in your Sentry project settings.

```ts sentry.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import * as Sentry from "@sentry/bun";

// Ensure to call this before importing any other modules!
Sentry.init({
  dsn: "__SENTRY_DSN__",

  // Add Performance Monitoring by setting tracesSampleRate
  // We recommend adjusting this value in production
  tracesSampleRate: 1.0,
});
```

***

You can verify that Sentry is working by capturing a test error:

```ts sentry.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
setTimeout(() => {
  try {
    foo();
  } catch (e) {
    Sentry.captureException(e);
  }
}, 99);
```

To view and resolve the recorded error, log into [sentry.io](https://sentry.io/) and open your project. Clicking on the error's title will open a page where you can see detailed information and mark it as resolved.

***

To learn more about Sentry and using the Sentry Bun SDK, view the [Sentry documentation](https://docs.sentry.io/platforms/javascript/guides/bun).


# Build an app with SolidStart and Bun
Source: https://bun.com/docs/guides/ecosystem/solidstart



Initialize a SolidStart app with `create-solid`. You can specify the `--solidstart` flag to create a SolidStart project, and `--ts` for TypeScript support. When prompted for a template, select `basic` for a minimal starter app.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun create solid my-app --solidstart --ts
```

```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
┌
 Create-Solid v0.6.11
│
◇  Project Name
│  my-app
│
◇  Which template would you like to use?
│  basic
│
◇  Project created 🎉
│
◇  To get started, run: ─╮
│                        │
│  cd my-app             │
│  bun install           │
│  bun dev               │
│                        │
├────────────────────────╯
```

***

As instructed by the `create-solid` CLI, install the dependencies.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
cd my-app
bun install
```

Then run the development server with `bun dev`.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun dev
```

```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
$ vinxi dev
vinxi v0.5.8
vinxi starting dev server

  ➜ Local:    http://localhost:3000/
  ➜ Network:  use --host to expose
```

Open [localhost:3000](http://localhost:3000). Any changes you make to `src/routes/index.tsx` will be hot-reloaded automatically.

***

Refer to the [SolidStart website](https://docs.solidjs.com/solid-start) for complete framework documentation.


# Server-side render (SSR) a React component
Source: https://bun.com/docs/guides/ecosystem/ssr-react



To get started, install `react` & `react-dom`:

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
# Any package manager can be used
bun add react react-dom
```

***

To render a React component to an HTML stream server-side (SSR):

```tsx ssr-react.tsx icon="file-code" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { renderToReadableStream } from "react-dom/server";

function Component(props: { message: string }) {
  return (
    <body>
      <h1>{props.message}</h1>
    </body>
  );
}

const stream = await renderToReadableStream(<Component message="Hello from server!" />);
```

***

Combining this with `Bun.serve()`, we get a simple SSR HTTP server:

```tsx server.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
Bun.serve({
  async fetch() {
    const stream = await renderToReadableStream(<Component message="Hello from server!" />);
    return new Response(stream, {
      headers: { "Content-Type": "text/html" },
    });
  },
});
```

***

React `19` and later includes an [SSR optimization](https://github.com/facebook/react/pull/25597) that takes advantage of Bun's "direct" `ReadableStream` implementation. If you run into an error like `export named 'renderToReadableStream' not found`, please make sure to install version `19` of `react` & `react-dom`, or import from `react-dom/server.browser` instead of `react-dom/server`. See [facebook/react#28941](https://github.com/facebook/react/issues/28941) for more information.


# Build an HTTP server using StricJS and Bun
Source: https://bun.com/docs/guides/ecosystem/stric



[StricJS](https://github.com/bunsvr) is a Bun framework for building high-performance web applications and APIs.

* **Fast** — Stric is one of the fastest Bun frameworks. See [benchmark](https://github.com/bunsvr/benchmark) for more details.
* **Minimal** — The basic components like `@stricjs/router` and `@stricjs/utils` are under 50kB and require no external dependencies.
* **Extensible** — Stric includes with a plugin system, dependency injection, and optional optimizations for handling requests.

***

Use `bun init` to create an empty project.

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
mkdir myapp
cd myapp
bun init
bun add @stricjs/router @stricjs/utils
```

***

To implement a simple HTTP server with StricJS:

```ts index.ts icon="file-code" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { Router } from "@stricjs/router";

export default new Router().get("/", () => new Response("Hi"));
```

***

To serve static files from `/public`:

```ts index.ts icon="file-code" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { dir } from "@stricjs/utils";

export default new Router().get("/", () => new Response("Hi")).get("/*", dir("./public"));
```

***

Run the file in watch mode to start the development server.

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun --watch run index.ts
```

***

For more info, see Stric's [documentation](https://stricjs.netlify.app).


# Build an app with SvelteKit and Bun
Source: https://bun.com/docs/guides/ecosystem/sveltekit



Use `sv create my-app` to create a SvelteKit project with SvelteKit CLI. Answer the prompts to select a template and set up your development environment.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bunx sv create my-app
```

```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
┌  Welcome to the Svelte CLI! (v0.5.7)
│
◇  Which template would you like?
│  SvelteKit demo
│
◇  Add type checking with Typescript?
│  Yes, using Typescript syntax
│
◆  Project created
│
◇  What would you like to add to your project?
│  none
│
◇  Which package manager do you want to install dependencies with?
│  bun
│
◇  Successfully installed dependencies
│
◇  Project next steps ─────────────────────────────────────────────────────╮
│                                                                          │
│  1: cd my-app                                                            │
│  2: git init && git add -A && git commit -m "Initial commit" (optional)  │
│  3: bun run dev -- --open                                                │
│                                                                          │
│  To close the dev server, hit Ctrl-C                                     │
│                                                                          │
│  Stuck? Visit us at https://svelte.dev/chat                              │
│                                                                          │
├──────────────────────────────────────────────────────────────────────────╯
│
└  You're all set!
```

***

Once the project is initialized, `cd` into the new project. You don't need to run 'bun install' since the dependencies are already installed.

Then start the development server with `bun --bun run dev`.

To run the dev server with Node.js instead of Bun, you can omit the `--bun` flag.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
cd my-app
bun --bun run dev
```

```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
  $ vite dev
  Forced re-optimization of dependencies

    VITE v5.4.10  ready in 424 ms

    ➜  Local:   http://localhost:5173/
    ➜  Network: use --host to expose
    ➜  press h + enter to show help
```

***

Visit [http://localhost:5173](http://localhost:5173/) in a browser to see the template app.

<Frame>
  ![SvelteKit app running](https://github.com/oven-sh/bun/assets/3084745/7c76eae8-78f9-44fa-9f15-1bd3ca1a47c0)
</Frame>

***

If you edit and save `src/routes/+page.svelte`, you should see your changes hot-reloaded in the browser.

***

To build for production, you'll need to add the right SvelteKit adapter. Currently we recommend the

`bun add -D svelte-adapter-bun`.

Now, make the following changes to your `svelte.config.js`.

```js svelte.config.js icon="file-code" theme={"theme":{"light":"github-light","dark":"dracula"}}
import adapter from "@sveltejs/adapter-auto"; // [!code --]
import adapter from "svelte-adapter-bun"; // [!code ++]
import { vitePreprocess } from "@sveltejs/vite-plugin-svelte";

/** @type {import('@sveltejs/kit').Config} */
const config = {
  // Consult https://svelte.dev/docs/kit/integrations#preprocessors
  // for more information about preprocessors
  preprocess: vitePreprocess(),

  kit: {
    // adapter-auto only supports some environments, see https://svelte.dev/docs/kit/adapter-auto for a list.
    // If your environment is not supported, or you settled on a specific environment, switch out the adapter.
    // See https://svelte.dev/docs/kit/adapters for more information about adapters.
    adapter: adapter(),
  },
};

export default config;
```

***

To build a production bundle:

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun --bun run build
```

```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
  $ vite build
  vite v5.4.10 building SSR bundle for production...
  "confetti" is imported from external module "@neoconfetti/svelte" but never used in "src/routes/sverdle/+page.svelte".
  ✓ 130 modules transformed.
  vite v5.4.10 building for production...
  ✓ 148 modules transformed.
  ...
  ✓ built in 231ms
  ...
  ✓ built in 899ms

  Run npm run preview to preview your production build locally.

  > Using svelte-adapter-bun
    ✔ Start server with: bun ./build/index.js
    ✔ done
```


# Run Bun as a daemon with systemd
Source: https://bun.com/docs/guides/ecosystem/systemd



[systemd](https://systemd.io) is an init system and service manager for Linux operating systems that manages the startup and control of system processes and services.

***

To run a Bun application as a daemon using **systemd** you'll need to create a *service file* in `/lib/systemd/system/`.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
cd /lib/systemd/system
touch my-app.service
```

***

Here is a typical service file that runs an application on system start. You can use this as a template for your own service. Replace `YOUR_USER` with the name of the user you want to run the application as. To run as `root`, replace `YOUR_USER` with `root`, though this is generally not recommended for security reasons.

Refer to the [systemd documentation](https://www.freedesktop.org/software/systemd/man/systemd.service.html) for more information on each setting.

```ini my-app.service icon="file-code" theme={"theme":{"light":"github-light","dark":"dracula"}}
[Unit]
# describe the app
Description=My App
# start the app after the network is available
After=network.target

[Service]
# usually you'll use 'simple'
# one of https://www.freedesktop.org/software/systemd/man/systemd.service.html#Type=
Type=simple
# which user to use when starting the app
User=YOUR_USER
# path to your application's root directory
WorkingDirectory=/home/YOUR_USER/path/to/my-app
# the command to start the app
# requires absolute paths
ExecStart=/home/YOUR_USER/.bun/bin/bun run index.ts
# restart policy
# one of {no|on-success|on-failure|on-abnormal|on-watchdog|on-abort|always}
Restart=always

[Install]
# start the app automatically
WantedBy=multi-user.target
```

***

If your application starts a webserver, note that non-`root` users are not able to listen on ports 80 or 443 by default. To permanently allow Bun to listen on these ports when executed by a non-`root` user, use the following command. This step isn't necessary when running as `root`.

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
setcap CAP_NET_BIND_SERVICE=+eip ~/.bun/bin/bun
```

***

With the service file configured, you can now *enable* the service. Once enabled, it will start automatically on reboot. This requires `sudo` permissions.

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
systemctl enable my-app
```

***

To start the service without rebooting, you can manually *start* it.

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
systemctl start my-app
```

***

Check the status of your application with `systemctl status`. If you've started your app successfully, you should see something like this:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
systemctl status my-app
```

```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
● my-app.service - My App
     Loaded: loaded (/lib/systemd/system/my-app.service; enabled; preset: enabled)
     Active: active (running) since Thu 2023-10-12 11:34:08 UTC; 1h 8min ago
   Main PID: 309641 (bun)
      Tasks: 3 (limit: 503)
     Memory: 40.9M
        CPU: 1.093s
     CGroup: /system.slice/my-app.service
             └─309641 /home/YOUR_USER/.bun/bin/bun run /home/YOUR_USER/application/index.ts
```

***

To update the service, edit the contents of the service file, then reload the daemon.

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
systemctl daemon-reload
```

***

For a complete guide on the service unit configuration, you can check [this page](https://www.freedesktop.org/software/systemd/man/systemd.service.html). Or refer to this cheatsheet of common commands:

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
systemctl daemon-reload # tell systemd that some files got changed
systemctl enable my-app # enable the app (to allow auto-start)
systemctl disable my-app # disable the app (turns off auto-start)
systemctl start my-app # start the app if is stopped
systemctl stop my-app # stop the app
systemctl restart my-app # restart the app
```


# Use TanStack Start with Bun
Source: https://bun.com/docs/guides/ecosystem/tanstack-start



[TanStack Start](https://tanstack.com/start/latest) is a full-stack framework powered by TanStack Router. It supports full-document SSR, streaming, server functions, bundling and more, powered by TanStack Router and [Vite](https://vite.dev/).

***

<Steps>
  <Step title="Create a new TanStack Start app">
    Use the interactive CLI to create a new TanStack Start app.

    ```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    bun create @tanstack/start@latest my-tanstack-app
    ```
  </Step>

  <Step title="Start the dev server">
    Change to the project directory and run the dev server with Bun.

    ```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    cd my-tanstack-app
    bun --bun run dev
    ```

    This starts the Vite dev server with Bun.
  </Step>

  <Step title="Update scripts in package.json">
    Modify the scripts field in your `package.json` by prefixing the Vite CLI commands with `bun --bun`. This ensures that Bun executes the Vite CLI for common tasks like `dev`, `build`, and `preview`.

    ```json package.json icon="file-json" theme={"theme":{"light":"github-light","dark":"dracula"}}
    {
      "scripts": {
        "dev": "bun --bun vite dev", // [!code ++]
        "build": "bun --bun vite build", // [!code ++]
        "serve": "bun --bun vite preview" // [!code ++]
      }
    }
    ```
  </Step>
</Steps>

***

## Hosting

To host your TanStack Start app, you can use [Nitro](https://nitro.build/) or a custom Bun server for production deployments.

<Tabs>
  <Tab title="Nitro">
    <Steps>
      <Step title="Add Nitro to your project">
        Add [Nitro](https://nitro.build/) to your project. This tool allows you to deploy your TanStack Start app to different platforms.

        ```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
        bun add nitro
        ```
      </Step>

      <Step title={<span>Update your <code>vite.config.ts</code> file</span>}>
        Update your `vite.config.ts` file to include the necessary plugins for TanStack Start with Bun.

        ```ts vite.config.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
        // other imports...
        import { nitro } from "nitro/vite"; // [!code ++]

        const config = defineConfig({
          plugins: [
            tanstackStart(),
            nitro({ preset: "bun" }), // [!code ++]
            // other plugins...
          ],
        });

        export default config;
        ```

        <Note>
          The `bun` preset is optional, but it configures the build output specifically for Bun's runtime.
        </Note>
      </Step>

      <Step title="Update the start command">
        Make sure `build` and `start` scripts are present in your `package.json` file:

        ```json package.json icon="file-json" theme={"theme":{"light":"github-light","dark":"dracula"}}
          {
            "scripts": {
              "build": "bun --bun vite build", // [!code ++]
              // The .output files are created by Nitro when you run `bun run build`.
              // Not necessary when deploying to Vercel.
              "start": "bun run .output/server/index.mjs" // [!code ++]
            }
          }
        ```

        <Note>
          You do **not** need the custom `start` script when deploying to Vercel.
        </Note>
      </Step>

      <Step title="Deploy your app">
        Check out one of our guides to deploy your app to a hosting provider.

        <Note>
          When deploying to Vercel, you can either add the `"bunVersion": "1.x"` to your `vercel.json` file, or add it to the `nitro` config in your `vite.config.ts` file:

          <Warning>
            Do **not** use the `bun` Nitro preset when deploying to Vercel.
          </Warning>

          ```ts vite.config.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
          export default defineConfig({
            plugins: [
              tanstackStart(),
              nitro({
                preset: "bun", // [!code --]
                vercel: { // [!code ++]
                  functions: { // [!code ++]
                    runtime: "bun1.x", // [!code ++]
                  }, // [!code ++]
              }, // [!code ++]
              }),
            ],
          });
          ```
        </Note>
      </Step>
    </Steps>
  </Tab>

  <Tab title="Custom Server">
    <Note>
      This custom server implementation is based on [TanStack's Bun template](https://github.com/TanStack/router/blob/main/examples/react/start-bun/server.ts). It provides fine-grained control over static asset serving, including configurable memory management that preloads small files into memory for fast serving while serving larger files on-demand. This approach is useful when you need precise control over resource usage and asset loading behavior in production deployments.
    </Note>

    <Steps>
      <Step title="Create the production server">
        Create a `server.ts` file in your project root with the following custom server implementation:

        ```ts server.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" expandable theme={"theme":{"light":"github-light","dark":"dracula"}}
        /**
        * TanStack Start Production Server with Bun
        *
        * A high-performance production server for TanStack Start applications that
        * implements intelligent static asset loading with configurable memory management.
        *
        * Features:
        * - Hybrid loading strategy (preload small files, serve large files on-demand)
        * - Configurable file filtering with include/exclude patterns
        * - Memory-efficient response generation
        * - Production-ready caching headers
        *
        * Environment Variables:
        *
        * PORT (number)
        *   - Server port number
        *   - Default: 3000
        *
        * ASSET_PRELOAD_MAX_SIZE (number)
        *   - Maximum file size in bytes to preload into memory
        *   - Files larger than this will be served on-demand from disk
        *   - Default: 5242880 (5MB)
        *   - Example: ASSET_PRELOAD_MAX_SIZE=5242880 (5MB)
        *
        * ASSET_PRELOAD_INCLUDE_PATTERNS (string)
        *   - Comma-separated list of glob patterns for files to include
        *   - If specified, only matching files are eligible for preloading
        *   - Patterns are matched against filenames only, not full paths
        *   - Example: ASSET_PRELOAD_INCLUDE_PATTERNS="*.js,*.css,*.woff2"
        *
        * ASSET_PRELOAD_EXCLUDE_PATTERNS (string)
        *   - Comma-separated list of glob patterns for files to exclude
        *   - Applied after include patterns
        *   - Patterns are matched against filenames only, not full paths
        *   - Example: ASSET_PRELOAD_EXCLUDE_PATTERNS="*.map,*.txt"
        *
        * ASSET_PRELOAD_VERBOSE_LOGGING (boolean)
        *   - Enable detailed logging of loaded and skipped files
        *   - Default: false
        *   - Set to "true" to enable verbose output
        *
        * ASSET_PRELOAD_ENABLE_ETAG (boolean)
        *   - Enable ETag generation for preloaded assets
        *   - Default: true
        *   - Set to "false" to disable ETag support
        *
        * ASSET_PRELOAD_ENABLE_GZIP (boolean)
        *   - Enable Gzip compression for eligible assets
        *   - Default: true
        *   - Set to "false" to disable Gzip compression
        *
        * ASSET_PRELOAD_GZIP_MIN_SIZE (number)
        *   - Minimum file size in bytes required for Gzip compression
        *   - Files smaller than this will not be compressed
        *   - Default: 1024 (1KB)
        *
        * ASSET_PRELOAD_GZIP_MIME_TYPES (string)
        *   - Comma-separated list of MIME types eligible for Gzip compression
        *   - Supports partial matching for types ending with "/"
        *   - Default: text/,application/javascript,application/json,application/xml,image/svg+xml
        *
        * Usage:
        *   bun run server.ts
        */

        import path from 'node:path'

        // Configuration
        const SERVER_PORT = Number(process.env.PORT ?? 3000)
        const CLIENT_DIRECTORY = './dist/client'
        const SERVER_ENTRY_POINT = './dist/server/server.js'

        // Logging utilities for professional output
        const log = {
          info: (message: string) => {
            console.log(`[INFO] ${message}`)
          },
          success: (message: string) => {
            console.log(`[SUCCESS] ${message}`)
          },
          warning: (message: string) => {
            console.log(`[WARNING] ${message}`)
          },
          error: (message: string) => {
            console.log(`[ERROR] ${message}`)
          },
          header: (message: string) => {
            console.log(`\n${message}\n`)
          },
        }

        // Preloading configuration from environment variables
        const MAX_PRELOAD_BYTES = Number(
          process.env.ASSET_PRELOAD_MAX_SIZE ?? 5 * 1024 * 1024, // 5MB default
        )

        // Parse comma-separated include patterns (no defaults)
        const INCLUDE_PATTERNS = (process.env.ASSET_PRELOAD_INCLUDE_PATTERNS ?? '')
          .split(',')
          .map((s) => s.trim())
          .filter(Boolean)
          .map((pattern: string) => convertGlobToRegExp(pattern))

        // Parse comma-separated exclude patterns (no defaults)
        const EXCLUDE_PATTERNS = (process.env.ASSET_PRELOAD_EXCLUDE_PATTERNS ?? '')
          .split(',')
          .map((s) => s.trim())
          .filter(Boolean)
          .map((pattern: string) => convertGlobToRegExp(pattern))

        // Verbose logging flag
        const VERBOSE = process.env.ASSET_PRELOAD_VERBOSE_LOGGING === 'true'

        // Optional ETag feature
        const ENABLE_ETAG = (process.env.ASSET_PRELOAD_ENABLE_ETAG ?? 'true') === 'true'

        // Optional Gzip feature
        const ENABLE_GZIP = (process.env.ASSET_PRELOAD_ENABLE_GZIP ?? 'true') === 'true'
        const GZIP_MIN_BYTES = Number(process.env.ASSET_PRELOAD_GZIP_MIN_SIZE ?? 1024) // 1KB
        const GZIP_TYPES = (
          process.env.ASSET_PRELOAD_GZIP_MIME_TYPES ??
          'text/,application/javascript,application/json,application/xml,image/svg+xml'
        )
          .split(',')
          .map((v) => v.trim())
          .filter(Boolean)

        /**
        * Convert a simple glob pattern to a regular expression
        * Supports * wildcard for matching any characters
        */
        function convertGlobToRegExp(globPattern: string): RegExp {
          // Escape regex special chars except *, then replace * with .*
          const escapedPattern = globPattern
            .replace(/[-/\\^$+?.()|[\]{}]/g, '\\$&')
            .replace(/\*/g, '.*')
          return new RegExp(`^${escapedPattern}$`, 'i')
        }

        /**
        * Compute ETag for a given data buffer
        */
        function computeEtag(data: Uint8Array): string {
          const hash = Bun.hash(data)
          return `W/"${hash.toString(16)}-${data.byteLength.toString()}"`
        }

        /**
        * Metadata for preloaded static assets
        */
        interface AssetMetadata {
          route: string
          size: number
          type: string
        }

        /**
        * In-memory asset with ETag and Gzip support
        */
        interface InMemoryAsset {
          raw: Uint8Array
          gz?: Uint8Array
          etag?: string
          type: string
          immutable: boolean
          size: number
        }

        /**
        * Result of static asset preloading process
        */
        interface PreloadResult {
          routes: Record<string, (req: Request) => Response | Promise<Response>>
          loaded: AssetMetadata[]
          skipped: AssetMetadata[]
        }

        /**
        * Check if a file is eligible for preloading based on configured patterns
        */
        function isFileEligibleForPreloading(relativePath: string): boolean {
          const fileName = relativePath.split(/[/\\]/).pop() ?? relativePath

          // If include patterns are specified, file must match at least one
          if (INCLUDE_PATTERNS.length > 0) {
            if (!INCLUDE_PATTERNS.some((pattern) => pattern.test(fileName))) {
              return false
            }
          }

          // If exclude patterns are specified, file must not match any
          if (EXCLUDE_PATTERNS.some((pattern) => pattern.test(fileName))) {
            return false
          }

          return true
        }

        /**
        * Check if a MIME type is compressible
        */
        function isMimeTypeCompressible(mimeType: string): boolean {
          return GZIP_TYPES.some((type) =>
            type.endsWith('/') ? mimeType.startsWith(type) : mimeType === type,
          )
        }

        /**
        * Conditionally compress data based on size and MIME type
        */
        function compressDataIfAppropriate(
          data: Uint8Array,
          mimeType: string,
        ): Uint8Array | undefined {
          if (!ENABLE_GZIP) return undefined
          if (data.byteLength < GZIP_MIN_BYTES) return undefined
          if (!isMimeTypeCompressible(mimeType)) return undefined
          try {
            return Bun.gzipSync(data.buffer as ArrayBuffer)
          } catch {
            return undefined
          }
        }

        /**
        * Create response handler function with ETag and Gzip support
        */
        function createResponseHandler(
          asset: InMemoryAsset,
        ): (req: Request) => Response {
          return (req: Request) => {
            const headers: Record<string, string> = {
              'Content-Type': asset.type,
              'Cache-Control': asset.immutable
                ? 'public, max-age=31536000, immutable'
                : 'public, max-age=3600',
            }

            if (ENABLE_ETAG && asset.etag) {
              const ifNone = req.headers.get('if-none-match')
              if (ifNone && ifNone === asset.etag) {
                return new Response(null, {
                  status: 304,
                  headers: { ETag: asset.etag },
                })
              }
              headers.ETag = asset.etag
            }

            if (
              ENABLE_GZIP &&
              asset.gz &&
              req.headers.get('accept-encoding')?.includes('gzip')
            ) {
              headers['Content-Encoding'] = 'gzip'
              headers['Content-Length'] = String(asset.gz.byteLength)
              const gzCopy = new Uint8Array(asset.gz)
              return new Response(gzCopy, { status: 200, headers })
            }

            headers['Content-Length'] = String(asset.raw.byteLength)
            const rawCopy = new Uint8Array(asset.raw)
            return new Response(rawCopy, { status: 200, headers })
          }
        }

        /**
        * Create composite glob pattern from include patterns
        */
        function createCompositeGlobPattern(): Bun.Glob {
          const raw = (process.env.ASSET_PRELOAD_INCLUDE_PATTERNS ?? '')
            .split(',')
            .map((s) => s.trim())
            .filter(Boolean)
          if (raw.length === 0) return new Bun.Glob('**/*')
          if (raw.length === 1) return new Bun.Glob(raw[0])
          return new Bun.Glob(`{${raw.join(',')}}`)
        }

        /**
        * Initialize static routes with intelligent preloading strategy
        * Small files are loaded into memory, large files are served on-demand
        */
        async function initializeStaticRoutes(
          clientDirectory: string,
        ): Promise<PreloadResult> {
          const routes: Record<string, (req: Request) => Response | Promise<Response>> =
            {}
          const loaded: AssetMetadata[] = []
          const skipped: AssetMetadata[] = []

          log.info(`Loading static assets from ${clientDirectory}...`)
          if (VERBOSE) {
            console.log(
              `Max preload size: ${(MAX_PRELOAD_BYTES / 1024 / 1024).toFixed(2)} MB`,
            )
            if (INCLUDE_PATTERNS.length > 0) {
              console.log(
                `Include patterns: ${process.env.ASSET_PRELOAD_INCLUDE_PATTERNS ?? ''}`,
              )
            }
            if (EXCLUDE_PATTERNS.length > 0) {
              console.log(
                `Exclude patterns: ${process.env.ASSET_PRELOAD_EXCLUDE_PATTERNS ?? ''}`,
              )
            }
          }

          let totalPreloadedBytes = 0

          try {
            const glob = createCompositeGlobPattern()
            for await (const relativePath of glob.scan({ cwd: clientDirectory })) {
              const filepath = path.join(clientDirectory, relativePath)
              const route = `/${relativePath.split(path.sep).join(path.posix.sep)}`

              try {
                // Get file metadata
                const file = Bun.file(filepath)

                // Skip if file doesn't exist or is empty
                if (!(await file.exists()) || file.size === 0) {
                  continue
                }

                const metadata: AssetMetadata = {
                  route,
                  size: file.size,
                  type: file.type || 'application/octet-stream',
                }

                // Determine if file should be preloaded
                const matchesPattern = isFileEligibleForPreloading(relativePath)
                const withinSizeLimit = file.size <= MAX_PRELOAD_BYTES

                if (matchesPattern && withinSizeLimit) {
                  // Preload small files into memory with ETag and Gzip support
                  const bytes = new Uint8Array(await file.arrayBuffer())
                  const gz = compressDataIfAppropriate(bytes, metadata.type)
                  const etag = ENABLE_ETAG ? computeEtag(bytes) : undefined
                  const asset: InMemoryAsset = {
                    raw: bytes,
                    gz,
                    etag,
                    type: metadata.type,
                    immutable: true,
                    size: bytes.byteLength,
                  }
                  routes[route] = createResponseHandler(asset)

                  loaded.push({ ...metadata, size: bytes.byteLength })
                  totalPreloadedBytes += bytes.byteLength
                } else {
                  // Serve large or filtered files on-demand
                  routes[route] = () => {
                    const fileOnDemand = Bun.file(filepath)
                    return new Response(fileOnDemand, {
                      headers: {
                        'Content-Type': metadata.type,
                        'Cache-Control': 'public, max-age=3600',
                      },
                    })
                  }

                  skipped.push(metadata)
                }
              } catch (error: unknown) {
                if (error instanceof Error && error.name !== 'EISDIR') {
                  log.error(`Failed to load ${filepath}: ${error.message}`)
                }
              }
            }

            // Show detailed file overview only when verbose mode is enabled
            if (VERBOSE && (loaded.length > 0 || skipped.length > 0)) {
              const allFiles = [...loaded, ...skipped].sort((a, b) =>
                a.route.localeCompare(b.route),
              )

              // Calculate max path length for alignment
              const maxPathLength = Math.min(
                Math.max(...allFiles.map((f) => f.route.length)),
                60,
              )

              // Format file size with KB and actual gzip size
              const formatFileSize = (bytes: number, gzBytes?: number) => {
                const kb = bytes / 1024
                const sizeStr = kb < 100 ? kb.toFixed(2) : kb.toFixed(1)

                if (gzBytes !== undefined) {
                  const gzKb = gzBytes / 1024
                  const gzStr = gzKb < 100 ? gzKb.toFixed(2) : gzKb.toFixed(1)
                  return {
                    size: sizeStr,
                    gzip: gzStr,
                  }
                }

                // Rough gzip estimation (typically 30-70% compression) if no actual gzip data
                const gzipKb = kb * 0.35
                return {
                  size: sizeStr,
                  gzip: gzipKb < 100 ? gzipKb.toFixed(2) : gzipKb.toFixed(1),
                }
              }

              if (loaded.length > 0) {
                console.log('\n📁 Preloaded into memory:')
                console.log(
                  'Path                                          │    Size │ Gzip Size',
                )
                loaded
                  .sort((a, b) => a.route.localeCompare(b.route))
                  .forEach((file) => {
                    const { size, gzip } = formatFileSize(file.size)
                    const paddedPath = file.route.padEnd(maxPathLength)
                    const sizeStr = `${size.padStart(7)} kB`
                    const gzipStr = `${gzip.padStart(7)} kB`
                    console.log(`${paddedPath} │ ${sizeStr} │  ${gzipStr}`)
                  })
              }

              if (skipped.length > 0) {
                console.log('\n💾 Served on-demand:')
                console.log(
                  'Path                                          │    Size │ Gzip Size',
                )
                skipped
                  .sort((a, b) => a.route.localeCompare(b.route))
                  .forEach((file) => {
                    const { size, gzip } = formatFileSize(file.size)
                    const paddedPath = file.route.padEnd(maxPathLength)
                    const sizeStr = `${size.padStart(7)} kB`
                    const gzipStr = `${gzip.padStart(7)} kB`
                    console.log(`${paddedPath} │ ${sizeStr} │  ${gzipStr}`)
                  })
              }
            }

            // Show detailed verbose info if enabled
            if (VERBOSE) {
              if (loaded.length > 0 || skipped.length > 0) {
                const allFiles = [...loaded, ...skipped].sort((a, b) =>
                  a.route.localeCompare(b.route),
                )
                console.log('\n📊 Detailed file information:')
                console.log(
                  'Status       │ Path                            │ MIME Type                    │ Reason',
                )
                allFiles.forEach((file) => {
                  const isPreloaded = loaded.includes(file)
                  const status = isPreloaded ? 'MEMORY' : 'ON-DEMAND'
                  const reason =
                    !isPreloaded && file.size > MAX_PRELOAD_BYTES
                      ? 'too large'
                      : !isPreloaded
                        ? 'filtered'
                        : 'preloaded'
                  const route =
                    file.route.length > 30
                      ? file.route.substring(0, 27) + '...'
                      : file.route
                  console.log(
                    `${status.padEnd(12)} │ ${route.padEnd(30)} │ ${file.type.padEnd(28)} │ ${reason.padEnd(10)}`,
                  )
                })
              } else {
                console.log('\n📊 No files found to display')
              }
            }

            // Log summary after the file list
            console.log() // Empty line for separation
            if (loaded.length > 0) {
              log.success(
                `Preloaded ${String(loaded.length)} files (${(totalPreloadedBytes / 1024 / 1024).toFixed(2)} MB) into memory`,
              )
            } else {
              log.info('No files preloaded into memory')
            }

            if (skipped.length > 0) {
              const tooLarge = skipped.filter((f) => f.size > MAX_PRELOAD_BYTES).length
              const filtered = skipped.length - tooLarge
              log.info(
                `${String(skipped.length)} files will be served on-demand (${String(tooLarge)} too large, ${String(filtered)} filtered)`,
              )
            }
          } catch (error) {
            log.error(
              `Failed to load static files from ${clientDirectory}: ${String(error)}`,
            )
          }

          return { routes, loaded, skipped }
        }

        /**
        * Initialize the server
        */
        async function initializeServer() {
          log.header('Starting Production Server')

          // Load TanStack Start server handler
          let handler: { fetch: (request: Request) => Response | Promise<Response> }
          try {
            const serverModule = (await import(SERVER_ENTRY_POINT)) as {
              default: { fetch: (request: Request) => Response | Promise<Response> }
            }
            handler = serverModule.default
            log.success('TanStack Start application handler initialized')
          } catch (error) {
            log.error(`Failed to load server handler: ${String(error)}`)
            process.exit(1)
          }

          // Build static routes with intelligent preloading
          const { routes } = await initializeStaticRoutes(CLIENT_DIRECTORY)

          // Create Bun server
          const server = Bun.serve({
            port: SERVER_PORT,

            routes: {
              // Serve static assets (preloaded or on-demand)
              ...routes,

              // Fallback to TanStack Start handler for all other routes
              '/*': (req: Request) => {
                try {
                  return handler.fetch(req)
                } catch (error) {
                  log.error(`Server handler error: ${String(error)}`)
                  return new Response('Internal Server Error', { status: 500 })
                }
              },
            },

            // Global error handler
            error(error) {
              log.error(
                `Uncaught server error: ${error instanceof Error ? error.message : String(error)}`,
              )
              return new Response('Internal Server Error', { status: 500 })
            },
          })

          log.success(`Server listening on http://localhost:${String(server.port)}`)
        }

        // Initialize the server
        initializeServer().catch((error: unknown) => {
          log.error(`Failed to start server: ${String(error)}`)
          process.exit(1)
        })
        ```
      </Step>

      <Step title="Update package.json scripts">
        Add a `start` script to run the custom server:

        ```json package.json icon="file-json" theme={"theme":{"light":"github-light","dark":"dracula"}}
        {
          "scripts": {
            "build": "bun --bun vite build",
            "start": "bun run server.ts" // [!code ++]
          }
        }
        ```
      </Step>

      <Step title="Build and run">
        Build your application and start the server:

        ```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
        bun run build
        bun run start
        ```

        The server will start on port 3000 by default (configurable via `PORT` environment variable).
      </Step>
    </Steps>
  </Tab>
</Tabs>

<Columns>
  <Card title="Vercel" href="/guides/deployment/vercel" icon="https://mintcdn.com/bun-1dd33a4e/cfVIaCNGtFU88Wgc/icons/ecosystem/vercel.svg?fit=max&auto=format&n=cfVIaCNGtFU88Wgc&q=85&s=7b490676c38ef9af753b06839da7b0d5">
    Deploy on Vercel
  </Card>

  <Card title="Render" href="/guides/deployment/render" icon="https://mintcdn.com/bun-1dd33a4e/cfVIaCNGtFU88Wgc/icons/ecosystem/render.svg?fit=max&auto=format&n=cfVIaCNGtFU88Wgc&q=85&s=5ac8410728c8e2d747afc287b0b715d9">
    Deploy on Render
  </Card>

  <Card title="Railway" href="/guides/deployment/railway" icon="https://mintcdn.com/bun-1dd33a4e/cfVIaCNGtFU88Wgc/icons/ecosystem/railway.svg?fit=max&auto=format&n=cfVIaCNGtFU88Wgc&q=85&s=da50a9424b0121975a3bd68e7038425e">
    Deploy on Railway
  </Card>

  <Card title="DigitalOcean" href="/guides/deployment/digital-ocean" icon="https://mintcdn.com/bun-1dd33a4e/cfVIaCNGtFU88Wgc/icons/ecosystem/digitalocean.svg?fit=max&auto=format&n=cfVIaCNGtFU88Wgc&q=85&s=b3f34ba0a9eb2c1968261738759f2542">
    Deploy on DigitalOcean
  </Card>

  <Card title="AWS Lambda" href="/guides/deployment/aws-lambda" icon="https://mintcdn.com/bun-1dd33a4e/cfVIaCNGtFU88Wgc/icons/ecosystem/aws.svg?fit=max&auto=format&n=cfVIaCNGtFU88Wgc&q=85&s=9733e5ae5faecf5974cbd02661e2b4f2">
    Deploy on AWS Lambda
  </Card>

  <Card title="Google Cloud Run" href="/guides/deployment/google-cloud-run" icon="https://mintcdn.com/bun-1dd33a4e/cfVIaCNGtFU88Wgc/icons/ecosystem/gcp.svg?fit=max&auto=format&n=cfVIaCNGtFU88Wgc&q=85&s=a99e6cb0cfadfeb9ea3b6451de38cfd6">
    Deploy on Google Cloud Run
  </Card>
</Columns>

***

## Templates

<Columns>
  <Card title="Todo App with Tanstack + Bun" href="https://github.com/bun-templates/bun-tanstack-todo">
    A Todo application built with Bun, TanStack Start, and PostgreSQL.
  </Card>

  <Card title="Bun + TanStack Start Application" href="https://github.com/bun-templates/bun-tanstack-basic">
    A TanStack Start template using Bun with SSR and file-based routing.
  </Card>

  <Card title="Basic Bun + Tanstack Starter" href="https://github.com/bun-templates/bun-tanstack-start">
    The basic TanStack starter using the Bun runtime and Bun's file APIs.
  </Card>
</Columns>

***

[→ See TanStack Start's official documentation](https://tanstack.com/start/latest/docs/framework/react/guide/hosting) for more information on hosting.


