"""Gera massa de dados única para cada execução dos testes."""
import random
import string
import uuid


class DataFactory:
    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def gerar_usuario(self, administrador=True):
        """Retorna um usuário com e-mail único, pronto para o POST /usuarios."""
        sufixo = uuid.uuid4().hex[:8]
        return {
            "nome": f"QA Robot {sufixo}",
            "email": f"qa.robot.{sufixo}@teste.com",
            "password": "".join(random.choices(string.ascii_letters + string.digits, k=10)),
            "administrador": "true" if str(administrador).lower() == "true" else "false",
        }

    def gerar_produto(self):
        """Retorna um produto com nome único, pronto para o POST /produtos."""
        sufixo = uuid.uuid4().hex[:8]
        return {
            "nome": f"Produto Robot {sufixo}",
            "preco": random.randint(10, 500),
            "descricao": "Produto criado pela automação",
            "quantidade": random.randint(1, 100),
        }