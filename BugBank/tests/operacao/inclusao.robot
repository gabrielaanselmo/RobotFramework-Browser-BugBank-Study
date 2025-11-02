*** Settings ***
Library    Browser
Resource   ../../../shared/login.robot
Resource   ../operacao/resources/pages/inclusao/bugbank.robot

*** Test Cases ***
Cenario: Cadastro E Login Com A Mesma Conta
    [Documentation]    Gera uma conta e tenta fazer login imediatamente.
    Given Que Eu Abro A Pagina Inicial Do BugBank
    When Eu Preencho O Cadastro Com Dados Padrao
    Then Devo Receber Uma Mensagem De Sucesso
    
    When Eu TENTO Logar Com A Conta Recem Criada
    And Eu Clico Em Acessar
    Then Devo Ser Redirecionado Para A Pagina Inicial

    And Eu Finalizo A Sessao