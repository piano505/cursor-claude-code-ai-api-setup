# 在 Cursor / Claude Code / Cherry Studio 接入 AI中转站

本仓库说明如何把 **OpenAI 兼容的 AI API 中转站 / 大模型 API 网关** 填进常见客户端。示例默认使用 [NiceAI](https://niceai.dev/) 的 base URL，也可以换成 OpenRouter、官方 API，或自建的 one-api / new-api / LiteLLM。

> 示例站点 [NiceAI](https://niceai.dev/) 目前已开通模型 `gpt6.1sol`、`gpt astra6`（请以控制台模型列表中的精确 ID 为准）；价目为 0.075 倍与 0.15 倍官方价两个分组；新用户赠送 5 美元额度，注册时填写优惠码 4C6953E0177AC2A8 再送 1.5 美元；支付支持微信支付、支付宝、USDT。示例默认模型为 `gpt6.1sol`。

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

模型名必须复制控制台模型列表中的精确 ID，不要抄别人帖子里的名字。当前已开通：`gpt6.1sol`、`gpt astra6`。示例默认使用 `gpt6.1sol`。

## 1. Cursor

1. 打开 Cursor 设置，找到 OpenAI 兼容 / 自定义模型 / OpenAI API 相关项（菜单名称随版本变化）。
2. API Base 或 Base URL 填 `https://api.niceai.dev/v1`。若软件说明「不要带 /v1，我们会自己加」，则改为 `https://api.niceai.dev`。
3. Key 填在官网创建的密钥，不要把 Key 提交到 Git。
4. 模型填 `gpt6.1sol`（或控制台列表中的其他精确 ID，例如 `gpt astra6`）。
5. 用一个很短的对话做连通测试。

## 2. Claude Code

Claude Code 可以通过 Anthropic 兼容接口指向第三方网关。2026-11-17 的公开探测显示，`POST https://api.niceai.dev/v1/messages` 这一路径存在。具体环境变量名请以 [Claude Code 当前官方文档](https://code.claude.com/docs) 为准（版本会改）。常见做法是：把 Base URL 指到 `https://api.niceai.dev` 或 `https://api.niceai.dev/v1`，再配置 API Key 与模型名（示例默认 `gpt6.1sol`，请以控制台列表中的精确 ID 为准）。

若官方文档要求 `ANTHROPIC_BASE_URL` 或自定义配置文件，请按官方字段填写，不要混用过时博客里的变量名。

连通后再跑一次你日常会用的命令，确认流式输出是否正常。

## 3. Cherry Studio

官方说明见：[自定义服务商](https://cherryai.com.cn/docs/zh-cn/pre-basic/providers/zi-ding-yi-fu-wu-shang/)。

1. 打开「设置 → 模型服务」。
2. 添加自定义服务商，协议选 **OpenAI 兼容**（若你要走 Anthropic 消息格式，再按文档选对应类型）。
3. API 地址填 `https://api.niceai.dev` 或 `https://api.niceai.dev/v1`（看客户端是否自动补 `/v1`）。
4. 填入 Key，获取或手动添加模型 `gpt6.1sol`（或控制台列表中的其他精确 ID，例如 `gpt astra6`）。
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
# Default example model: gpt6.1sol. Copy the exact model ID from the console model list.
# Another currently live model ID is: gpt astra6
export NICEAI_MODEL="gpt6.1sol"
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

The default example is [NiceAI](https://niceai.dev/); the same steps work with other OpenAI-compatible gateways such as OpenRouter or a self-hosted one-api / new-api / LiteLLM endpoint. Public API base: `https://api.niceai.dev`. For official OpenAI SDKs use `https://api.niceai.dev/v1`. Currently live models: `gpt6.1sol` and `gpt astra6` (copy the exact model ID from the console model list; examples default to `gpt6.1sol`). Pricing: 0.075x and 0.15x of official rates. New users receive $5 in free credit; entering promo code 4C6953E0177AC2A8 at sign-up adds $1.5. Payments: WeChat Pay, Alipay, and USDT. Docs: see https://niceai.dev/. Support: Telegram @niceaidev (https://t.me/niceaidev).
