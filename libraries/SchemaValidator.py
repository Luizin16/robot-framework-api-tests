"""Validação de contrato da resposta da API com JSON Schema."""
import json
from pathlib import Path

from jsonschema import Draft7Validator

SCHEMAS = Path(__file__).resolve().parent.parent / "schemas"


class SchemaValidator:
    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def validar_contrato(self, resposta, nome_schema):
        """Falha listando todos os campos fora do contrato definido em schemas/<nome_schema>.json."""
        schema = json.loads((SCHEMAS / f"{nome_schema}.json").read_text(encoding="utf-8"))
        erros = sorted(Draft7Validator(schema).iter_errors(resposta), key=lambda e: list(e.path))
        if erros:
            detalhes = "\n".join(f"- {'/'.join(map(str, e.path)) or 'raiz'}: {e.message}" for e in erros)
            raise AssertionError(f"Resposta fora do contrato '{nome_schema}':\n{detalhes}")