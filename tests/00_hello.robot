*** Settings ***
Documentation    Primeiro teste para validar o ambiente.

*** Test Cases ***
Ambiente deve estar funcionando
    ${soma}=    Evaluate    2 + 2
    Should Be Equal As Integers    ${soma}    4
    Log    Robot Framework rodando!