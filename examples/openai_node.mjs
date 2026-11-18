/**
 * Official OpenAI Node SDK against an OpenAI-compatible relay (NiceAI).
 *
 *   npm install openai
 *   export NICEAI_API_KEY="sk-..."
 *   export NICEAI_BASE_URL="https://api.niceai.dev/v1"
 *   export NICEAI_MODEL="gpt-6.1-sol"
 * Default example model: gpt-6.1-sol. Copy the exact model ID from the console model list.
 * Another currently live model ID is: gpt-6-astro
 *   node examples/openai_node.mjs
 */
import OpenAI from "openai";

if (!process.env.NICEAI_API_KEY) {
  console.error("Set NICEAI_API_KEY. Do not hard-code secrets.");
  process.exit(1);
}

const client = new OpenAI({
  apiKey: process.env.NICEAI_API_KEY,
  baseURL: process.env.NICEAI_BASE_URL || "https://api.niceai.dev/v1",
});

const resp = await client.chat.completions.create({
  model: process.env.NICEAI_MODEL || "gpt-6.1-sol",
  messages: [{ role: "user", content: "Reply with the word pong." }],
});

console.log(resp.choices[0].message.content);
