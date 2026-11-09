*** Settings ***
Documentation    Keywords do serviço SOAP de calculadora (http://www.dneonline.com/calculator.asmx).
Library          RequestsLibrary
Library          XML

*** Variables ***
${BASE_URL_SOAP}    http://www.dneonline.com
${SESSAO_SOAP}      calculadora
${ENVELOPE}         <?xml version="1.0" encoding="utf-8"?>
...                 <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
...                 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
...                 xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
...                 <soap:Body><{operacao} xmlns="http://tempuri.org/">
...                 <intA>{a}</intA><intB>{b}</intB>
...                 </{operacao}></soap:Body></soap:Envelope>
...                 separator=${SPACE}

*** Keywords ***
Criar Sessao SOAP
    Create Session    ${SESSAO_SOAP}    ${BASE_URL_SOAP}

Chamar Operacao
    [Documentation]    Monta o envelope SOAP da operação (Add, Subtract, Multiply, Divide) e envia.
    [Arguments]    ${operacao}    ${a}    ${b}
    ${corpo}=    Evaluate    $ENVELOPE.format(operacao=$operacao, a=$a, b=$b)
    &{headers}=    Create Dictionary
    ...    Content-Type=text/xml; charset=utf-8
    ...    SOAPAction="http://tempuri.org/${operacao}"
    ${resposta}=    POST On Session    ${SESSAO_SOAP}    /calculator.asmx    data=${corpo.encode('utf-8')}
    ...    headers=${headers}    expected_status=anything
    RETURN    ${resposta}

Resultado Da Operacao Deve Ser
    [Documentation]    Lê o <OperacaoResult> do XML de resposta, ignorando os namespaces.
    [Arguments]    ${resposta}    ${operacao}    ${esperado}
    Status Should Be    200    ${resposta}
    ${xml}=    Parse Xml    ${resposta.text}    strip_namespaces=True
    ${resultado}=    Get Element Text    ${xml}    .//${operacao}Result
    Should Be Equal As Integers    ${resultado}    ${esperado}

Resposta Deve Ser Um SOAP Fault
    [Arguments]    ${resposta}
    Status Should Be    500    ${resposta}
    ${xml}=    Parse Xml    ${resposta.text}    strip_namespaces=True
    Element Should Exist    ${xml}    .//Fault/faultstring