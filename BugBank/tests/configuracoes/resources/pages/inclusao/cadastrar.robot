*** Settings ***
Documentation    Testes para o fluxo de cadastro de novos usuários no BugBank (Estilo BDD sem argumentos).
Resource         ../../../../../../shared/login.robot
Library          String
Library          FakerLibrary

*** Variables ***
${SALDO_INICIAL_TOGGLE}     True
${BTN_REGISTRAR}            css=#__next > div > div.pages__FormBackground-sc-1ee1f2s-2.jNpkvU > div > div.card__login > form > div.login__buttons > button.style__ContainerButton-sc-1wsixal-0.ihdmxA.button__child
${INPUT_EMAIL}              xpath=(//input[@placeholder='Informe seu e-mail'])[2]
${INPUT_NOME}               css=input[placeholder='Informe seu Nome']
${INPUT_SENHA}              xpath=(//input[@placeholder='Informe sua senha'])[2]
${INPUT_CONF_SENHA}         xpath=(//input[@placeholder='Informe a confirmação da senha'])[1]

${TOGGLE_SALDO}             id=toggleAddBalance
${BTN_CADASTRAR}            xpath=(//button[normalize-space()='Cadastrar'])[1]
${MSG_CADASTRO_SUCESSO}     id=modalText

*** Keywords ***
Given Que Eu Abro A Pagina Inicial Do BugBank
    [Documentation]    Condição inicial para o teste BDD, usando a keyword do resource file.
    Abrir BugBank

When Eu Preencho O Cadastro Com Dados Padrao
    [Documentation]    Clica em Registrar e preenche o formulário usando as variáveis definidas.
    Click    ${BTN_REGISTRAR}
    Wait For Elements State    ${INPUT_EMAIL}    visible
    ${EMAIL_ALEATORIO} =    FakerLibrary.Email
    Fill Text    ${INPUT_EMAIL}         ${EMAIL_ALEATORIO}
    ${NOME_ALEATORIO} =     FakerLibrary.Name
    Fill Text    ${INPUT_NOME}          ${NOME_ALEATORIO}
    ${SENHA_ALEATORIO} =    FakerLibrary.Password
    Fill Text    ${INPUT_SENHA}         ${SENHA_ALEATORIO}
    Fill Text    ${INPUT_CONF_SENHA}    ${SENHA_ALEATORIO}
    IF    '${SALDO_INICIAL_TOGGLE}' == 'True'
        Click    ${TOGGLE_SALDO}
    END
    Click    ${BTN_CADASTRAR}

Then Devo Receber Uma Mensagem De Sucesso
    [Documentation]    Verifica a mensagem de sucesso dinâmica e fecha o modal.
    Wait For Elements State    ${MSG_CADASTRO_SUCESSO}    visible
    ${success_message}=    Get Text    ${MSG_CADASTRO_SUCESSO}
    Should Match Regexp    ${success_message}    ^A conta [0-9]{3}-[0-9] foi criada com sucesso$
    ${account_number}=    Get Regexp Matches    ${success_message}    ([0-9]{3}-[0-9])
    Log    Conta criada: ${account_number[0]}