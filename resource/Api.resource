*** Settings ***
Documentation   Documentacao da API: https://points-app-backend.vercel.app/docs
Library     RequestsLibrary
Library     Collections
Library     String
Library     JSONLibrary
Library     FakerLibrary    locale=pt_BR
Library     ../scripts/cpf_library.py

*** Variables ***
${BASE_URL}     https://points-app-backend.vercel.app/
${TOKEN}    ${None}
${ENDPOINT_CADASTRO}    cadastro
${ENDPOINT_CONFIRM_EMAIL}    confirm-email
${ENDPOINT_LOGIN}    login
${ENDPOINT_CADASTRO_SOFT_DELETE}    account
${ENDPOINT_POINTS_SEND}    points/send
${ENDPOINT_POINTS_RECEIVE}    points/extrato
${ENDPOINT_POINTS_SALDO}    points/saldo
${ENDPOINT_CAIXINHA_DEPOSIT}    caixinha/deposit
${ENDPOINT_CAIXINHA_WITHDRAW}    caixinha/withdraw
${ENDPOINT_CAIXINHA_EXTRATO}    caixinha/extrato

*** Keywords ***
Create Session API
    Create Session  base_url  ${BASE_URL}  disable_warnings=True  verify=False  auth=None  timeout=None  proxies=None  headers={}  cookies={}
    #auth=None #timeout=None #proxies=None #headers={Create Dictionary} #coockes{Create Dictionary}

POST /cadastro valido com cpf e email gerado
    [Documentation]     Cria um novo usuario
    [Arguments]    ${fullName}    ${password}    ${confirmPassword}
    ${EMAILFAKE}                FakerLibrary.Email
    ${CPFFake}                  Gerar CPF Valido

    
    ${DATA_BODY}=   Create Dictionary  cpf=${CPFFake}  full_name=${fullName}  email=${EMAILFAKE}  password=${password}  confirmPassword=${confirmPassword}
    ${HEADERS}=     Create Dictionary  Content-Type=application/json
    ${RESPONSE}=     POST On Session     base_url      ${ENDPOINT_CADASTRO}     json=${DATA_BODY}    headers=${HEADERS}
 
    ${TOKEN}=      Convert To String    ${RESPONSE.json()['confirmToken']}
    Set Suite Variable    ${TOKEN}
    Set Suite Variable    ${RESPONSE}
    Set Suite Variable    ${EMAILFAKE}
    Set Suite Variable    ${password}

POST /cadastro
    [Documentation]     Cria um novo usuario
    [Arguments]    ${cpf}    ${email}    ${fullName}    ${password}    ${confirmPassword}
    
    
    ${DATA_BODY}=   Create Dictionary  cpf=${cpf}  full_name=${fullName}  email=${email}  password=${password}  confirmPassword=${confirmPassword}
    ${HEADERS}=     Create Dictionary  Content-Type=application/json
    ${RESPONSE}=     POST On Session     base_url      ${ENDPOINT_CADASTRO}     json=${DATA_BODY}    headers=${HEADERS}    expected_status=ANY
    Set Suite Variable    ${RESPONSE}
 
Armazena valor do saldo
    ${normal_balance}    Convert To String    ${RESPONSE.json()}[normal_balance]
    Set Suite Variable    ${normal_balance}

Valida valor total do saldo
    ${soma}   Evaluate     ${normal_balance}-${amount}
    ${valorAtual}=      Convert To String    ${RESPONSE.json()['normal_balance']}
    Should Be Equal As Integers    ${soma}    ${valorAtual}
    
POST /points/send
    [Documentation]     Envia pontos para o usuario
    [Arguments]    ${recipientCpf}    ${amount}
    ${DATA_BODY}=   Create Dictionary  recipientCpf=${recipientCpf}    amount=${amount}
    ${HEADERS}=     Create Dictionary  Content-Type=application/json  Authorization=Bearer ${TOKEN}
    ${RESPONSE}=     POST On Session     base_url      ${ENDPOINT_POINTS_SEND}     json=${DATA_BODY}    headers=${HEADERS}    expected_status=ANY

    Set Suite Variable    ${RESPONSE}
    Set Suite Variable    ${amount}
     

POST /caixinha/deposit
    [Documentation]     Deposita pontos na caixinha do usuario
    [Arguments]    ${amount}
    ${TOKEN}=      Convert To String    ${RESPONSE.json()['token']}
    Set Suite Variable    ${TOKEN}
    ${DATA_BODY}=   Create Dictionary  amount=${amount}
    ${HEADERS}=     Create Dictionary  Content-Type=application/json  Authorization=Bearer ${TOKEN}
    ${RESPONSE}=     POST On Session     base_url      ${ENDPOINT_CAIXINHA_DEPOSIT}     json=${DATA_BODY}    headers=${HEADERS}    expected_status=ANY

    Set Suite Variable    ${RESPONSE}
     

POST /caixinha/withdraw
    [Documentation]     Retira pontos da caixinha do usuario
    [Arguments]    ${amount}
    ${TOKEN}=      Convert To String    ${RESPONSE.json()['token']}
    Set Suite Variable    ${TOKEN}
    ${HEADERS}=     Create Dictionary  Content-Type=application/json  Authorization=Bearer ${TOKEN}
    ${DATA_BODY}=   Create Dictionary  amount=${amount}
    ${RESPONSE}=    POST On Session  base_url  ${ENDPOINT_CAIXINHA_WITHDRAW}  headers=${HEADERS}    json=${DATA_BODY}    expected_status=ANY

    Set Suite Variable    ${RESPONSE}
     
GET /caixinha/extrato
    [Documentation]     Retorna o extrato da caixinha do usuario
    
    ${HEADERS}=     Create Dictionary  Content-Type=application/json  Authorization=Bearer ${TOKEN}
    ${RESPONSE}=    GET On Session  base_url  ${ENDPOINT_CAIXINHA_EXTRATO}  headers=${HEADERS}    expected_status=ANY

    Set Suite Variable    ${RESPONSE}
     

GET /points/extrato
    [Documentation]     Retorna o extrato de pontos do usuario
    ${HEADERS}=     Create Dictionary  Content-Type=application/json  Authorization=Bearer ${TOKEN}
    ${RESPONSE}=    GET On Session  base_url  ${ENDPOINT_POINTS_RECEIVE}  headers=${HEADERS}    expected_status=ANY

    Set Suite Variable    ${RESPONSE}
     
GET /points/saldo
    [Documentation]     Retorna o saldo de pontos do usuario
    ${HEADERS}=     Create Dictionary  Content-Type=application/json  Authorization=Bearer ${TOKEN}
    ${RESPONSE}=    GET On Session  base_url  ${ENDPOINT_POINTS_SALDO}  headers=${HEADERS}    expected_status=ANY

    Set Suite Variable    ${RESPONSE}
    
GET /confirm-email
    [Documentation]     Confirma o email do usuario
    ${RESPONSE}=    GET On Session  base_url  ${ENDPOINT_CONFIRM_EMAIL}  params=token=${TOKEN}    expected_status=ANY
    Set Suite Variable    ${TOKEN}
    Set Suite Variable    ${RESPONSE}

GET /confirm-email com token
    [Documentation]     Confirma o email do usuario
    [Arguments]    ${token}
    ${RESPONSE}=    GET On Session  base_url  ${ENDPOINT_CONFIRM_EMAIL}  params=token=${token}    expected_status=ANY
    Set Suite Variable    ${TOKEN}
    Set Suite Variable    ${RESPONSE}
    
POST /login com dados criados
    [Documentation]     Realiza o login do usuario
    
    ${HEADERS}=     Create Dictionary  Content-Type=application/json  Authorization=Bearer ${TOKEN}
    ${DATA_BODY}=   Create Dictionary  email=${EMAILFAKE}  password=${password}
    ${RESPONSE}=     POST On Session     base_url      ${ENDPOINT_LOGIN}     json=${DATA_BODY}    headers=${HEADERS}    expected_status=ANY
    ${TOKEN}=      Convert To String    ${RESPONSE.json()['token']}
    Set Suite Variable    ${TOKEN}
    Set Suite Variable    ${RESPONSE}

POST /login
    [Documentation]     Realiza o login do usuario
    [Arguments]    ${email}    ${password}
    ${HEADERS}=     Create Dictionary  Content-Type=application/json  Authorization=Bearer ${TOKEN}
    ${DATA_BODY}=   Create Dictionary  email=${email}  password=${password}
    ${RESPONSE}=     POST On Session     base_url      ${ENDPOINT_LOGIN}     json=${DATA_BODY}    headers=${HEADERS}    expected_status=ANY  
    Set Suite Variable    ${RESPONSE}

Armazena o token
    ${TOKEN}=      Convert To String    ${RESPONSE.json()['token']}
    Set Suite Variable    ${TOKEN}
DELETE /account
    [Documentation]     Realiza o soft delete da conta do usuario
    ${HEADERS}=     Create Dictionary  Content-Type=application/json  Authorization=Bearer ${TOKEN}
    ${DATA_BODY}=   Create Dictionary  password=${password}
    ${RESPONSE}=        DELETE On Session   base_url      ${ENDPOINT_CADASTRO_SOFT_DELETE}  json=${DATA_BODY}  headers=${HEADERS}    expected_status=ANY

    Set Suite Variable    ${TOKEN}
    Set Suite Variable    ${RESPONSE}

DELETE /account com password
    [Documentation]     Realiza o soft delete da conta do usuario
    [Arguments]    ${password}
    ${HEADERS}=     Create Dictionary  Content-Type=application/json  Authorization=Bearer ${TOKEN}
    ${DATA_BODY}=   Create Dictionary  password=${password}
    ${RESPONSE}=        DELETE On Session   base_url      ${ENDPOINT_CADASTRO_SOFT_DELETE}  json=${DATA_BODY}  headers=${HEADERS}    expected_status=ANY

    Set Suite Variable    ${TOKEN}
    Set Suite Variable    ${RESPONSE}  


Validate Dict Item
    [Documentation]     Valida se o dicionario possui o item
    [Arguments]     ${KEY}  ${VALUE}
    Dictionary Should Contain Item    ${RESPONSE.json()}    ${KEY}  ${VALUE}
     
Validate Status Code
    [Documentation]     Valida o status code da resposta
    [Arguments]        ${STATUS_CODE_EXPECTED}
    Should Be Equal As Integers    ${RESPONSE.status_code}    ${STATUS_CODE_EXPECTED}
   

Validate Content
    [Documentation]     Valida o conteudo da resposta
     [Arguments]    ${CONTENT_EXPECTED}
     ${BODY}=       Convert To String    ${RESPONSE.content}
     Should Contain    ${BODY}    ${CONTENT_EXPECTED}

Validate not empyt
    [Documentation]     Valida se o campo nao veio em branco
    [Arguments]     ${KEY}
    Should Not Be Empty    ${RESPONSE.json()}    ${KEY}