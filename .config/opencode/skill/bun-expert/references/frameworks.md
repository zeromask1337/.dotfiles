# Build an app with Astro and Bun
Source: https://bun.com/docs/guides/ecosystem/astro



Initialize a fresh Astro app with `bun create astro`. The `create-astro` package detects when you are using `bunx` and will automatically install dependencies using `bun`.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun create astro
```

```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
╭─────╮  Houston:
│ ◠ ◡ ◠  We're glad to have you on board.
╰─────╯

 astro   v3.1.4 Launch sequence initiated.

   dir   Where should we create your new project?
         ./fumbling-field

  tmpl   How would you like to start your new project?
         Use blog template
      ✔  Template copied

  deps   Install dependencies?
         Yes
      ✔  Dependencies installed

    ts   Do you plan to write TypeScript?
         Yes

   use   How strict should TypeScript be?
         Strict
      ✔  TypeScript customized

   git   Initialize a new git repository?
         Yes
      ✔  Git initialized

  next   Liftoff confirmed. Explore your project!

         Enter your project directory using cd ./fumbling-field
         Run `bun run dev` to start the dev server. CTRL+C to stop.
         Add frameworks like react or tailwind using astro add.

         Stuck? Join us at https://astro.build/chat

╭─────╮  Houston:
│ ◠ ◡ ◠  Good luck out there, astronaut! 🚀
╰─────╯
```

***

Start the dev server with `bunx`.

By default, Bun will run the dev server with Node.js. To use the Bun runtime instead, use the `--bun` flag.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bunx --bun astro dev
```

```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
  🚀  astro  v3.1.4 started in 200ms

  ┃ Local    http://localhost:4321/
  ┃ Network  use --host to expose
```

***

Open [http://localhost:4321](http://localhost:4321) with your browser to see the result. Astro will hot-reload your app as you edit your source files.

<Frame>
  <img />
</Frame>

***

Refer to the [Astro docs](https://docs.astro.build/en/getting-started/) for complete documentation.


# Create a Discord bot
Source: https://bun.com/docs/guides/ecosystem/discordjs



Discord.js works out of the box with Bun. Let's write a simple bot. First create a directory and initialize it with `bun init`.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
mkdir my-bot
cd my-bot
bun init
```

***

Now install Discord.js.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun add discord.js
```

***

Before we go further, we need to go to the [Discord developer portal](https://discord.com/developers/applications), login/signup, create a new *Application*, then create a new *Bot* within that application. Follow the [official guide](https://discordjs.guide/legacy/preparations/app-setup#creating-your-bot) for step-by-step instructions.

***

Once complete, you'll be presented with your bot's *private key*. Let's add this to a file called `.env.local`. Bun automatically reads this file and loads it into `process.env`.

<Note>This is an example token that has already been invalidated.</Note>

```ini .env.local icon="settings" theme={"theme":{"light":"github-light","dark":"dracula"}}
DISCORD_TOKEN=YOUR_BOT_TOKEN_HERE
```

***

Be sure to add `.env.local` to your `.gitignore`! It is dangerous to check your bot's private key into version control.

```txt .gitignore icon="file-code" theme={"theme":{"light":"github-light","dark":"dracula"}}
node_modules
.env.local
```

***

Now let's actually write our bot in a new file called `bot.ts`.

```ts bot.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
// import discord.js
import { Client, Events, GatewayIntentBits } from "discord.js";

// create a new Client instance
const client = new Client({ intents: [GatewayIntentBits.Guilds] });

// listen for the client to be ready
client.once(Events.ClientReady, c => {
  console.log(`Ready! Logged in as ${c.user.tag}`);
});

// login with the token from .env.local
client.login(process.env.DISCORD_TOKEN);
```

***

Now we can run our bot with `bun run`. It may take a several seconds for the client to initialize the first time you run the file.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun run bot.ts
```

```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
Ready! Logged in as my-bot#1234
```

***

You're up and running with a bare-bones Discord.js bot! This is a basic guide to setting up your bot with Bun; we recommend the [official discord.js docs](https://discordjs.guide/) for complete information on the `discord.js` API.


# Build an HTTP server using Elysia and Bun
Source: https://bun.com/docs/guides/ecosystem/elysia



[Elysia](https://elysiajs.com) is a Bun-first performance focused web framework that takes full advantage of Bun's HTTP, file system, and hot reloading APIs. Get started with `bun create`.

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun create elysia myapp
cd myapp
bun run dev
```

***

To define a simple HTTP route and start a server with Elysia:

```ts server.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { Elysia } from "elysia";

const app = new Elysia().get("/", () => "Hello Elysia").listen(8080);

console.log(`🦊 Elysia is running at on port ${app.server?.port}...`);
```

***

Elysia is a full-featured server framework with Express-like syntax, type inference, middleware, file uploads, and plugins for JWT authentication, tRPC, and more. It's also is one of the [fastest Bun web frameworks](https://github.com/SaltyAom/bun-http-framework-benchmark).

Refer to the Elysia [documentation](https://elysiajs.com/quick-start.html) for more information.


# Build an HTTP server using Express and Bun
Source: https://bun.com/docs/guides/ecosystem/express



Express and other major Node.js HTTP libraries should work out of the box. Bun implements the [`node:http`](https://nodejs.org/api/http.html) and [`node:https`](https://nodejs.org/api/https.html) modules that these libraries rely on.

<Note>
  Refer to the [Runtime > Node.js APIs](/runtime/nodejs-compat#node-http) page for more detailed compatibility
  information.
</Note>

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun add express
```

***

To define a simple HTTP route and start a server with Express:

```ts server.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import express from "express";

const app = express();
const port = 8080;

app.get("/", (req, res) => {
  res.send("Hello World!");
});

app.listen(port, () => {
  console.log(`Listening on port ${port}...`);
});
```

***

To start the server on `localhost`:

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun server.ts
```


# Build an HTTP server using Hono and Bun
Source: https://bun.com/docs/guides/ecosystem/hono



[Hono](https://github.com/honojs/hono) is a lightweight ultrafast web framework designed for the edge.

```ts server.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
import { Hono } from "hono";
const app = new Hono();

app.get("/", c => c.text("Hono!"));

export default app;
```

***

Use `create-hono` to get started with one of Hono's project templates. Select `bun` when prompted for a template.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun create hono myapp
```

```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
✔ Which template do you want to use? › bun
cloned honojs/starter#main to /path/to/myapp
✔ Copied project files
```

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
cd myapp
bun install
```

***

Then start the dev server and visit [localhost:3000](http://localhost:3000).

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun run dev
```

***

Refer to Hono's guide on [getting started with Bun](https://hono.dev/getting-started/bun) for more information.


# Build an app with Next.js and Bun
Source: https://bun.com/docs/guides/ecosystem/nextjs



[Next.js](https://nextjs.org/) is a React framework for building full-stack web applications. It supports server-side rendering, static site generation, API routes, and more. Bun provides fast package installation and can run Next.js development and production servers.

***

<Steps>
  <Step title="Create a new Next.js app">
    Use the interactive CLI to create a new Next.js app. This will scaffold a new Next.js project and automatically install dependencies.

    ```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    bun create next-app@latest my-bun-app
    ```
  </Step>

  <Step title="Start the dev server">
    Change to the project directory and run the dev server with Bun.

    ```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
    cd my-bun-app
    bun --bun run dev
    ```

    This starts the Next.js dev server with Bun's runtime.

    Open [`http://localhost:3000`](http://localhost:3000) with your browser to see the result. Any changes you make to `app/page.tsx` will be hot-reloaded in the browser.
  </Step>

  <Step title="Update scripts in package.json">
    Modify the scripts field in your `package.json` by prefixing the Next.js CLI commands with `bun --bun`. This ensures that Bun executes the Next.js CLI for common tasks like `dev`, `build`, and `start`.

    ```json package.json icon="file-json" theme={"theme":{"light":"github-light","dark":"dracula"}}
    {
      "scripts": {
        "dev": "bun --bun next dev", // [!code ++]
        "build": "bun --bun next build", // [!code ++]
        "start": "bun --bun next start", // [!code ++]
      }
    }
    ```
  </Step>
</Steps>

***

## Hosting

Next.js applications on Bun can be deployed to various platforms.

<Columns>
  <Card title="Vercel" href="/guides/deployment/vercel" icon="https://mintcdn.com/bun-1dd33a4e/cfVIaCNGtFU88Wgc/icons/ecosystem/vercel.svg?fit=max&auto=format&n=cfVIaCNGtFU88Wgc&q=85&s=7b490676c38ef9af753b06839da7b0d5">
    Deploy on Vercel
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

  <Card title="Render" href="/guides/deployment/render" icon="https://mintcdn.com/bun-1dd33a4e/cfVIaCNGtFU88Wgc/icons/ecosystem/render.svg?fit=max&auto=format&n=cfVIaCNGtFU88Wgc&q=85&s=5ac8410728c8e2d747afc287b0b715d9">
    Deploy on Render
  </Card>
</Columns>

***

## Templates

<Columns>
  <Card title="Bun + Next.js Basic Starter" href="https://github.com/bun-templates/bun-nextjs-basic">
    A simple App Router starter with Bun, Next.js, and Tailwind CSS.
  </Card>

  <Card title="Todo App with Next.js + Bun" href="https://github.com/bun-templates/bun-nextjs-todo">
    A full-stack todo application built with Bun, Next.js, and PostgreSQL.
  </Card>
</Columns>

***

[→ See Next.js's official documentation](https://nextjs.org/docs) for more information on building and deploying Next.js applications.


# Build an app with Nuxt and Bun
Source: https://bun.com/docs/guides/ecosystem/nuxt



Bun supports [Nuxt](https://nuxt.com) out of the box. Initialize a Nuxt app with official `nuxi` CLI.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bunx nuxi init my-nuxt-app
```

```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
✔ Which package manager would you like to use?
bun
◐ Installing dependencies...
bun install v1.3.3 (16b4bf34)
 + @nuxt/devtools@0.8.2
 + nuxt@3.7.0
 785 packages installed [2.67s]
✔ Installation completed.
✔ Types generated in .nuxt
✨ Nuxt project has been created with the v3 template. Next steps:
 › cd my-nuxt-app
 › Start development server with bun run dev
```

***

To start the dev server, run `bun --bun run dev` from the project root. This will execute the `nuxt dev` command (as defined in the `"dev"` script in `package.json`).

<Note>
  The `nuxt` CLI uses Node.js by default; passing the `--bun` flag forces the dev server to use the Bun runtime instead.
</Note>

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
cd my-nuxt-app
bun --bun run dev
```

```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
nuxt dev
Nuxi 3.6.5
Nuxt 3.6.5 with Nitro 2.5.2
  > Local:    http://localhost:3000/
  > Network:  http://192.168.0.21:3000/
  > Network:  http://[fd8a:d31d:481c:4883:1c64:3d90:9f83:d8a2]:3000/

✔ Nuxt DevTools is enabled v0.8.0 (experimental)
ℹ Vite client warmed up in 547ms
✔ Nitro built in 244 ms
```

***

Once the dev server spins up, open [http://localhost:3000](http://localhost:3000) to see the app. The app will render Nuxt's built-in `NuxtWelcome` template component.

To start developing your app, replace `<NuxtWelcome />` in `app.vue` with your own UI.

<Frame>
  ![Demo Nuxt app running on
  localhost](https://github.com/oven-sh/bun/assets/3084745/2c683ecc-3298-4bb0-b8c0-cf4cfaea1daa)
</Frame>

***

For production build, while the default preset is already compatible with Bun, you can also use [Bun preset](https://nitro.build/deploy/runtimes/bun) to generate better optimized builds.

```ts nuxt.config.ts icon="https://mintcdn.com/bun-1dd33a4e/Hq64iapoQXHbYMEN/icons/typescript.svg?fit=max&auto=format&n=Hq64iapoQXHbYMEN&q=85&s=c6cceedec8f82d2cc803d7c6ec82b240" theme={"theme":{"light":"github-light","dark":"dracula"}}
export default defineNuxtConfig({
  nitro: {
    preset: "bun", // [!code ++]
  },
});
```

Alternatively, you can set the preset via environment variable:

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
NITRO_PRESET=bun bun run build
```

<Note>
  Some packages provide Bun-specific exports that Nitro will not bundle correctly using the default preset. In this
  case, you need to use Bun preset so that the packages will work correctly in production builds.
</Note>

After building with bun, run:

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun run ./.output/server/index.mjs
```

***

Refer to the [Nuxt website](https://nuxt.com/docs) for complete documentation.


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


# Build a frontend using Vite and Bun
Source: https://bun.com/docs/guides/ecosystem/vite



<Note>
  You can use Vite with Bun, but many projects get faster builds & drop hundreds of dependencies by switching to [HTML
  imports](/bundler/html-static).
</Note>

***

Vite works out of the box with Bun. Get started with one of Vite's templates.

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun create vite my-app
```

```txt theme={"theme":{"light":"github-light","dark":"dracula"}}
✔ Select a framework: › React
✔ Select a variant: › TypeScript + SWC
Scaffolding project in /path/to/my-app...
```

***

Then `cd` into the project directory and install dependencies.

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
cd my-app
bun install
```

***

Start the development server with the `vite` CLI using `bunx`.

The `--bun` flag tells Bun to run Vite's CLI using `bun` instead of `node`; by default Bun respects Vite's `#!/usr/bin/env node` [shebang line](https://en.wikipedia.org/wiki/Shebang_\(Unix\)).

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bunx --bun vite
```

***

To simplify this command, update the `"dev"` script in `package.json` to the following.

```json package.json icon="file-json" theme={"theme":{"light":"github-light","dark":"dracula"}}
  "scripts": {
    "dev": "vite", // [!code --]
    "dev": "bunx --bun vite", // [!code ++]
    "build": "vite build",
    "serve": "vite preview"
  },
  // ...
```

***

Now you can start the development server with `bun run dev`.

```bash terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bun run dev
```

***

The following command will build your app for production.

```sh terminal icon="terminal" theme={"theme":{"light":"github-light","dark":"dracula"}}
bunx --bun vite build
```

***

This is a stripped down guide to get you started with Vite + Bun. For more information, see the [Vite documentation](https://vite.dev/guide/).


