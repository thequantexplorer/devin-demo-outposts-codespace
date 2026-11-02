# Devin demo: Run Devin on your own cloud machine with Outposts

**What it shows:** Devin runs a session on a machine you own. Here that machine is a GitHub Codespace in your browser. The tests need Typst, which is installed only in the Codespace, so they can only pass there.

**Needs:** GitHub, and a Devin Pro, Max or Teams plan ([Outposts](https://docs.devin.ai/cloud/outposts/overview) is on those plans). Codespaces use your GitHub account's free monthly hours.

More demos: [devin-advanced-demos](https://github.com/thequantexplorer/devin-advanced-demos)

## How it works

An **outpost** is a named queue of Devin sessions. A **worker** is a machine that takes sessions from that queue. Devin still thinks and plans in its cloud, but every command and file edit runs on the worker. In this lab, the worker is your Codespace.

## Set it up

1. Click **Use this template → Create a new repository**, choose your GitHub account as the owner, and keep the name `devin-demo-outposts-codespace`. The links and prompt below assume that name.
2. In Devin, open [**Settings → Connections → GitHub**](https://app.devin.ai/settings/connections/github) and make sure Devin can access the new repository.
3. Create the outpost. In Devin, go to **Settings → Environment → Outposts** and click **Create Outpost**. Name it `codespace`, choose **Linux**, and create it. Copy the Outpost token now. Devin shows it only once.
4. Save the token as a Codespaces secret. On GitHub, click your profile picture, then **Settings**. In the sidebar, under **Code, planning, and automation**, click **Codespaces**. Under **Codespaces secrets**, click **New secret**. Set **Name** to `DEVIN_OUTPOSTS_TOKEN`, paste the token into **Value**, pick `devin-demo-outposts-codespace` under **Repository access**, and click **Add secret**.
5. Open the Codespace. On your repository page, click **Code**, open the **Codespaces** tab, and click **Create codespace on main**. Setup takes 2 to 3 minutes. It installs Typst, pytest and the Devin CLI.
6. Start the worker. In the Codespace terminal, run:

   ```sh
   bash scripts/start-worker.sh
   ```

   Wait for `Worker started!`. Leave this terminal and the Codespace tab open.
7. Start a session at [app.devin.ai](https://app.devin.ai). Before you send it, click **Configuration**, open **Virtual environment**, and pick `codespace`.

## Prompt

Paste this into the session. Replace `<you>` with your GitHub user.

```text
This session runs on my Devin Outpost, a GitHub Codespace. My repo https://github.com/<you>/devin-demo-outposts-codespace is already checked out on this machine under repos/devin-demo-outposts-codespace. Work there. Do not clone it again and do not install any tools.

1. Run `bash scripts/machine-info.sh` and show me the output.
2. Run `python -m pytest` and show me which tests fail.
3. Read the billing rules in README.md, find the bug, and fix it with the smallest change.
4. Run `python -m pytest` again until every test passes.
5. Open a pull request with the fix. In the description, include the machine-info output and the test results from before and after the fix.
```

## What to watch

- The worker terminal in the Codespace prints a line when it picks up the session.
- `machine-info.sh` shows your Codespace's name and `typst 0.13.1`.
- The files change in the Codespace editor while Devin works.

## Done when

- The pull request has the machine-info output and all 10 tests passing.
- The fix computes tax after the discount, in `invoices/template.typ`.

## Clean up

Press **Ctrl+C** in the worker terminal. Then stop or delete the Codespace at [github.com/codespaces](https://github.com/codespaces) so it stops using your free hours.

## If something goes wrong

- **`DEVIN_OUTPOSTS_TOKEN is not set`:** check the secret at [github.com/settings/codespaces](https://github.com/settings/codespaces) and its **Repository access**. A new secret reaches only Codespaces started after it was added, so stop and restart the Codespace.
- **The Codespace stopped:** Codespaces stop after 30 idle minutes. Open it again and rerun `bash scripts/start-worker.sh`.
- **The session waits and nothing happens:** check that the worker terminal is still running and that you picked `codespace` under **Virtual environment**.
- **You named the outpost something else:** run `DEVIN_OUTPOST_NAME=<name> bash scripts/start-worker.sh`.
