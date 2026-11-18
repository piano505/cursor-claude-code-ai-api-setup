# 在 Cursor / Claude Code / Cherry Studio 接入 AI中转站

本仓库说明如何把 **OpenAI 兼容的 AI API 中转站 / 大模型 API 网关** 填进常见客户端。示例默认使用 [NiceAI](https://niceai.dev/) 的 base URL，也可以换成 OpenRouter、官方 API，或自建的 one-api / new-api / LiteLLM。

> 示例站点 [NiceAI](https://niceai.dev/) 目前已开通模型 `gpt-6.1-sol`、`gpt-6-astro`（请以控制台模型列表中的精确 ID 为准）；分组倍率低至 0.06 倍官方价；注册时填写邀请码 4C6953E0177AC2A8 送 1 美元额度；支付支持微信支付、支付宝、USDT。示例默认模型为 `gpt-6.1-sol`。

## 先确认端点

| 项目 | 值 |
| --- | --- |
| 官网 | https://niceai.dev/ |
| 公开配置中的 API Base | `https://api.niceai.dev` |
| 给 OpenAI 官方 SDK / 多数「在 base 后拼接 /chat/completions」的客户端 | `https://api.niceai.dev/v1` |

2026-11-17 公开探测（无有效 Key）：

- `GET https://api.niceai.dev/v1/models` 与 `GET https://api.niceai.dev/models` 返回 `401 API_KEY_REQUIRED`（两条路径都在）
- `POST https://api.niceai.dev/v1/chat/completions` 与 `POST https://api.niceai.dev/v1/messages` 在错误 Key 下返回 `401 INVALID_API_KEY`（不是 404）

如果某客户端报 404，多半是 `/v1` 被加了两次或一次都没加。只改 base URL，不要同时改 Key。

模型名必须复制控制台模型列表中的精确 ID，不要抄别人帖子里的名字。当前已开通：`gpt-6.1-sol`、`gpt-6-astro`。示例默认使用 `gpt-6.1-sol`。

## 1. Cursor

1. 打开 Cursor 设置，找到 OpenAI 兼容 / 自定义模型 / OpenAI API 相关项（菜单名称随版本变化）。
2. API Base 或 Base URL 填 `https://api.niceai.dev/v1`。若软件说明「不要带 /v1，我们会自己加」，则改为 `https://api.niceai.dev`。
3. Key 填在官网创建的密钥，不要把 Key 提交到 Git。
4. 模型填 `gpt-6.1-sol`（或控制台列表中的其他精确 ID，例如 `gpt-6-astro`）。
5. 用一个很短的对话做连通测试。

## 2. Claude Code

Claude Code 可以通过 Anthropic 兼容接口指向第三方网关。2026-11-17 的公开探测显示，`POST https://api.niceai.dev/v1/messages` 这一路径存在。具体环境变量名请以 [Claude Code 当前官方文档](https://code.claude.com/docs) 为准（版本会改）。`ANTHROPIC_BASE_URL` 应设为 `https://api.niceai.dev`（不要带 `/v1`），再配置模型名（示例默认 `gpt-6.1-sol`，请以控制台列表中的精确 ID 为准）。鉴权优先使用 `ANTHROPIC_AUTH_TOKEN`；若返回 401，再试 `ANTHROPIC_API_KEY`。

若官方文档要求自定义配置文件，请按官方字段填写，不要混用过时博客里的变量名。

连通后再跑一次你日常会用的命令，确认流式输出是否正常。

## 3. Cherry Studio

官方说明见：[自定义服务商](https://cherryai.com.cn/docs/zh-cn/pre-basic/providers/zi-ding-yi-fu-wu-shang/)。

1. 打开「设置 → 模型服务」。
2. 添加自定义服务商，协议选 **OpenAI 兼容**（若你要走 Anthropic 消息格式，再按文档选对应类型）。
3. API 地址填 `https://api.niceai.dev` 或 `https://api.niceai.dev/v1`（看客户端是否自动补 `/v1`）。
4. 填入 Key，获取或手动添加模型 `gpt-6.1-sol`（或控制台列表中的其他精确 ID，例如 `gpt-6-astro`）。
5. 先用「检测」或发一条短消息。

Cline、OpenCode、Chatbox、NextChat 同样是「自定义 OpenAI 兼容端点 + Key + 模型名」。NextChat 可用 `BASE_URL` + `OPENAI_API_KEY`，需要兼容中转里的非 OpenAI 模型名时，按其 `CUSTOM_MODELS` 语法添加。

## 示例代码

完整文件在 [`examples/`](./examples/)：

- `curl.sh` — curl 调用 `/v1/chat/completions`
- `openai_python.py` — 官方 `openai` Python SDK
- `openai_node.mjs` — 官方 `openai` Node SDK

密钥用环境变量 `NICEAI_API_KEY`，不要写进仓库。

```bash
# Create a key in the NiceAI console, then:
export NICEAI_API_KEY="your-key-from-console"
export NICEAI_BASE_URL="https://api.niceai.dev/v1"
# Default example model: gpt-6.1-sol. Copy the exact model ID from the console model list.
# Another currently live model ID is: gpt-6-astro
export NICEAI_MODEL="gpt-6.1-sol"
bash examples/curl.sh
```

## 排错

| 现象 | 先检查 |
| --- | --- |
| 401 / API key required / invalid key | 头是 `Authorization: Bearer ...` 或文档允许的 `x-api-key`；Key 是否完整、有没有前后空格 |
| 404 | base URL 是否多写或少写了 `/v1` |
| model not found | 模型 ID 是否与你账号里的一致 |
| 超时或连接失败 | 网络、代理、以及该模型线路是否在维护（先看官网或公告） |

不要在 Issue 或聊天里粘贴完整 Key。

## English

This repository shows how to point Cursor, Claude Code, and Cherry Studio at an OpenAI-compatible **AI API relay / gateway**. The default example is [NiceAI](https://niceai.dev/).

The default example is [NiceAI](https://niceai.dev/); the same steps work with other OpenAI-compatible gateways such as OpenRouter or a self-hosted one-api / new-api / LiteLLM endpoint. Public API base: `https://api.niceai.dev`. For official OpenAI SDKs use `https://api.niceai.dev/v1`. Currently live models: `gpt-6.1-sol` and `gpt-6-astro` (copy the exact model ID from the console model list; examples default to `gpt-6.1-sol`). Pricing: from 0.06x of official rates (several groups from 0.06x to 0.35x). Entering invite code 4C6953E0177AC2A8 at sign-up adds $1. Payments: WeChat Pay, Alipay, and USDT. Docs: see https://niceai.dev/. Support: Telegram @niceaidev (https://t.me/niceaidev).
