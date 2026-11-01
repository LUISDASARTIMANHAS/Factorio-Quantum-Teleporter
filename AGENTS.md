# Instrucoes para agentes e desenvolvedores

## Contexto do projeto

- Este repositorio contem o mod **Quantum Teleporter** para Factorio 2.1 e a expansao Space Age.
- O objetivo do mod e permitir que o jogador se teletransporte pelo mapa e entre planetas.
- Consulte `info.json` para a versao do jogo, dependencias e metadados oficiais do mod. A dependencia da LDA-LIB deve permanecer compativel com a versao minima declarada ali.
- O projeto usa Lua e os estagios de dados e runtime do Factorio. Respeite as APIs e restricoes especificas de cada estagio.

## Estrutura principal

- `control.lua` e o ponto de entrada do runtime; os modulos de runtime ficam principalmente em `control/`.
- `data.lua` carrega prototipos e configuracoes de dados; os modulos correspondentes ficam principalmente em `data/`.
- `graphics/` contem recursos visuais e estilos.
- `locale/pt-BR/` e `locale/en/` contem as traducoes. Atualize os dois idiomas quando adicionar ou alterar textos apresentados ao jogador.
- `docs/factorio-LDA-LIB/` e uma copia da LDA-LIB disponibilizada exclusivamente para consulta.
- `utils/` e o local do projeto para helpers temporarios que ainda nao existam na LDA-LIB. Crie essa pasta quando necessario; mantenha helpers especificos de estagio organizados sem misturar APIs de data-stage e runtime.

## Regra obrigatoria: usar a LDA-LIB

Antes de implementar uma funcao utilitaria ou um padrao reutilizavel:

1. Verifique se a LDA-LIB ja oferece a funcionalidade.
2. Consulte a API e os exemplos da copia em `docs/factorio-LDA-LIB/`, incluindo `README.md`, `USAGE.md` e os modulos relevantes.
3. Confirme a assinatura e a disponibilidade da funcao na versao minima da biblioteca exigida em `info.json`.
4. Se a funcionalidade existir, use a LDA-LIB em vez de criar uma implementacao local duplicada.

A copia em `docs/factorio-LDA-LIB/` e somente para leitura e informacao: nao a edite, nao a use como destino de correcoes e nao trate alteracoes nela como contribuicoes oficiais a LDA-LIB. O mod deve continuar consumindo a biblioteca como dependencia, conforme sua integracao existente.

### Quando a funcao necessaria nao existir na LDA-LIB

- Informe claramente ao usuario que a funcionalidade e uma **request feature to LDA-LIB**, descrevendo a funcao necessaria e seu objetivo. Nao afirme que a solicitacao foi enviada se isso nao aconteceu.
- Registre cada funcionalidade que precisa ser requisitada em `request-feature.md`, seguindo o formato definido nesse arquivo. Atualize o registro em vez de criar listas paralelas em outros arquivos.
- Enquanto a funcao nao estiver oficialmente disponivel, implemente somente o helper necessario dentro de `utils/` neste projeto.
- Mantenha essa implementacao local pequena, documentada quando necessario e isolada para facilitar sua substituicao. Nao altere a copia em `docs/` nem finja que o helper ja faz parte da biblioteca.
- Quando a funcionalidade for incorporada oficialmente e estiver disponivel na versao compativel, migre os usos para a LDA-LIB e remova o helper temporario se ele nao tiver outros consumidores.

## Diretrizes de desenvolvimento

- Leia os arquivos e os usos existentes antes de alterar o comportamento; preserve convencoes de nomes, organizacao e chamadas `require`.
- Mantenha codigo de data-stage e runtime separado. Nao use APIs de jogo em um estagio no qual elas nao estao disponiveis.
- Prefira alteracoes pequenas e focadas. Preserve compatibilidade com Factorio 2.1, Space Age e a versao minima da LDA-LIB.
- Valide entradas e estados antes de operar sobre jogadores, entidades, superficies ou elementos de GUI. Trate erros de forma explicita e evite falhas silenciosas.
- Nao inclua credenciais, tokens ou outros segredos no repositorio. Nao leia nem exponha arquivos locais de ambiente, como `.env`, sem necessidade para a tarefa.
- Nao sobrescreva alteracoes existentes ou staged que nao pertencam a tarefa.
- Atualize documentacao relacionada quando uma mudanca alterar comportamento, configuracao ou instrucoes de uso.

## Validacao

- Procure primeiro por testes, verificacoes ou comandos ja existentes no repositorio e execute os que forem relevantes.
- Se nao houver verificacao automatizada aplicavel, informe isso e descreva a validacao manual apropriada no Factorio.
- Nunca declare testes, builds ou verificacoes como executados sem realmente executa-los.
