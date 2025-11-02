*** Settings ***
Library    Browser
Resource   ../../../shared/login.robot
Resource   ../operacao/resources/pages/inclusao/bugbank.robot

*** Test Cases ***
Cenario 01: Fluxo Completo: Cadastro, Login e Tentativa de Transferencia Invalida
    [Tags]   E2E     Negativo

    Given Que Eu Abro A Pagina Inicial Do BugBank
    When Eu Preencho O Cadastro Com Dados Padrao
    Then Devo Receber Uma Mensagem De Sucesso
    
    # --- CONTINUAÇÃO NO MESMO NAVEGADOR ---
    When Eu TENTO Logar Com A Conta Recem Criada
    And Eu Clico Em Acessar
    Then Devo Ser Redirecionado Para A Pagina Inicial
    
    # --- FLUXO DE TRANSFERÊNCIA ---
    When Eu TENTO Fazer Uma Transferencia Invalida
    Then Devo Receber Uma Mensagem De Erro Conta inválida ou inexistente