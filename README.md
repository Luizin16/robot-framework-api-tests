# Testes de API REST e SOAP com Robot Framework

![Testes de API](../../actions/workflows/testes-api.yml/badge.svg)

Automação de testes de API com **Robot Framework** e **Python**, usando a API pública [ServeRest](https://serverest.dev).

## O que é testado

| Suíte | Cenários |
| --- | --- |
| Usuários | Cadastro, persistência, contrato JSON Schema, e-mail duplicado, campo obrigatório, exclusão |
| Login | Token Bearer com contrato validado, senha inválida, e-mail inexistente |
| Produtos | Cadastro por administrador, sem token (401), usuário comum (403) |
| SOAP | Em andamento: envelope XML, SOAPAction e leitura com XPath |

## Destaques

- Keywords de negócio separadas dos detalhes de HTTP (`resources/`)
- Bibliotecas Python próprias: geração de massa única (`DataFactory`) e validação de contrato (`SchemaValidator`)
- Cada teste cria e apaga os próprios dados, sem deixar sujeira no ambiente
- CI no GitHub Actions com execução diária

## Como rodar

    pip install -r requirements.txt
    robot -d results tests

## Autor

**Luiz Alves** · [LinkedIn](https://www.linkedin.com/in/luiz-alves-candido-da-silva/) · [Portfólio](https://luizin16.github.io)