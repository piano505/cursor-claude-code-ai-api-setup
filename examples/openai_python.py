"""
OpenAI official Python SDK against an OpenAI-compatible relay (NiceAI).

  pip install openai
  export NICEAI_API_KEY="sk-..."
  export NICEAI_BASE_URL="https://api.niceai.dev/v1"
  export NICEAI_MODEL="gpt6.1sol"
  # Default example model: gpt6.1sol. Copy the exact model ID from the console model list.
  # Another currently live model ID is: gpt astra6
  python examples/openai_python.py
"""

import os
from openai import OpenAI

api_key = os.environ.get("NICEAI_API_KEY")
if not api_key:
    raise SystemExit("Set NICEAI_API_KEY. Do not hard-code secrets.")

client = OpenAI(
    api_key=api_key,
    base_url=os.environ.get("NICEAI_BASE_URL", "https://api.niceai.dev/v1"),
)

resp = client.chat.completions.create(
    model=os.environ.get("NICEAI_MODEL", "gpt6.1sol"),
    messages=[{"role": "user", "content": "Reply with the word pong."}],
)

print(resp.choices[0].message.content)
