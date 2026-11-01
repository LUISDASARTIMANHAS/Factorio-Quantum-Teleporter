# Solicitacoes de funcionalidades para a LDA-LIB

Use este arquivo como registro central de todas as funcionalidades que precisem ser requisitadas a LDA-LIB.

## Regras

- Antes de abrir um pedido, confirme que a funcao ou funcionalidade nao existe na versao compativel da LDA-LIB. Consulte `docs/factorio-LDA-LIB/`, que e somente para leitura.
- Registre aqui cada necessidade identificada, incluindo o objetivo e o uso neste mod. Nao mantenha listas duplicadas em outros arquivos.
- Informe o usuario sobre a necessidade da **request feature to LDA-LIB** e sobre a implementacao temporaria local em `utils/`.
- Use `Pendente de envio` ate que o pedido tenha sido realmente enviado. So marque como `Solicitada` quando houver evidencia de envio; nao afirme que um pedido foi enviado sem realiza-lo.
- Quando a funcionalidade estiver oficialmente disponivel em uma versao compativel, atualize o status para `Disponivel`, registre a versao e migre o mod para a API oficial.
- Nao registre como pedido uma funcionalidade que ja exista na biblioteca ou que nao seja necessaria para este projeto.

## Modelo de registro

Copie este modelo para cada nova solicitacao:

### [Nome curto da funcionalidade]

- **Status:** Pendente de envio
- **Funcao/API solicitada:** nome e comportamento esperado
- **Necessidade no mod:** problema que precisa ser resolvido e beneficio esperado
- **Estagio do Factorio:** data-stage, runtime ou ambos
- **Uso no projeto:** arquivos ou modulos que precisam da funcionalidade
- **Implementacao temporaria:** caminho do helper em `utils/`, se ja criado
- **Compatibilidade:** versao minima compativel esperada
- **Observacoes:** limitacoes, parametros ou requisitos relevantes

---

## Solicitacoes Registradas

### Builder de Prototipo de Acumulador (createAccumulator)

- **Status:** Pendente de envio
- **Funcao/API solicitada:** `LDA.createAccumulator(params)` (em `data-stage.builders.base.create-accumulator` e exportada via `init.lua`). Deve construir um protótipo `type = "accumulator"` modular aceitando nome, ícone, tamanho de colisão/seleção via bounding box, capacidade do buffer elétrico, limites de fluxo de entrada e saída (`input_flow_limit`, `output_flow_limit`), gráficos estáticos ou carregáveis (`chargable_graphics`), sons de operação e resistências.
- **Necessidade no mod:** O Portal Quântico precisa ser uma estrutura de armazenamento de energia (acumulador) para conectar-se à rede elétrica e acumular energia de teletransporte sem apresentar janelas de montagem/receitas. Atualmente a LDA-LIB possui apenas `createEntity` (voltado exclusivamente a painéis solares), forçando a criação de protótipos manuais ou helpers locais.
- **Estagio do Factorio:** data-stage
- **Uso no projeto:** `data/blocos/quantum-teleporter-portal.lua`
- **Implementacao temporaria:** `data/utils.lua` (`functions.createAccumulator`)
- **Compatibilidade:** LDA-LIB >= 0.0.16, Factorio 2.1+
- **Observacoes:** Deve permitir `output_flow_limit = "0kW"` para permitir acumuladores que retêm energia para uso exclusivo de scripts sem devolver carga para a rede comum.

### Modulo de Rede de Entidades (runtime.modules.network)

- **Status:** Pendente de envio
- **Funcao/API solicitada:** `LDARuntime.network` (com funções como `register(network_name, entity, metadata)`, `unregister(network_name, entity_or_id)`, `getAll(network_name, force_name)`, `get(network_name, unit_number)`, `setName(network_name, unit_number, name)` e `findFreeSpawnPosition(entity, target_name, radius)`).
- **Necessidade no mod:** O sistema de portais interligados precisa registrar e persistir em `storage` todos os portais existentes no universo, rastrear adições/remoções por robôs ou jogadores, validar a validade das entidades (`entity.valid`), e permitir consultas filtradas por força/time e superfície para montar rotas de teletransporte.
- **Estagio do Factorio:** runtime
- **Uso no projeto:** `control/portal.lua`, `control/gui/portal-gui.lua`
- **Implementacao temporaria:** `control/utils/portal-network.lua`
- **Compatibilidade:** LDA-LIB >= 0.0.16, Factorio 2.1+
- **Observacoes:** Deve persistir os dados na tabela global `storage` introduzida no Factorio 2.0+ e efetuar auto-limpeza de entidades que se tornaram inválidas sem disparo de evento.

### Helpers de Interface Grafica (runtime.modules.gui)

- **Status:** Pendente de envio
- **Funcao/API solicitada:** `LDARuntime.gui` (funções auxiliares para GUI de mods, como `findElementByName(root_element, name)` para busca recursiva segura em hierarquias complexas de containers, padronização de criação de janelas modais vinculadas a `player.opened` com botão fechar no titlebar, e formatação/criação de barras de status de energia).
- **Necessidade no mod:** As janelas do Portal e do Equipamento possuem layouts estruturados com múltiplos fluxos aninhados (`flows`, `frames`). A busca recursiva de elementos e a vinculação correta ao ciclo de vida do jogador evita duplicação de código e falhas de interface.
- **Estagio do Factorio:** runtime
- **Uso no projeto:** `control/gui/portal-gui.lua`, `control/gui/gui-maker.lua`
- **Implementacao temporaria:** `control/gui/portal-gui.lua` (`find_element_by_name`)
- **Compatibilidade:** LDA-LIB >= 0.0.16, Factorio 2.1+
- **Observacoes:** A API de GUI do Factorio não fornece busca recursiva nativa em elementos filhos; um helper desse tipo em biblioteca compartilhada padroniza o tratamento de eventos e modais em todos os mods.

### Correcao de Colisao no Registro de Comandos do Runtime (runtime.commands / runtime.init)

- **Status:** Pendente de envio
- **Funcao/API solicitada:** Proteção contra registro duplicado em `commands.register()` e isolamento do ponto de entrada do runtime. Em `runtime/commands.lua`, deve-se checar se o comando já existe (`if commands.commands["lda-list"] then return end`) ou registrar comandos apenas quando executado pelo mod base (`if script and script.mod_name == "LDA-LIB"`). Alternativamente, o `runtime/init.lua` não deve executar `commands.register()` incondicionalmente no top-level quando importado por mods terceiros como biblioteca.
- **Necessidade no mod:** Quando outro mod faz `require("__LDA-LIB__/runtime.init")`, o Factorio lança o erro fatal: `A script command already exists with the name: lda-list`, pois a LDA-LIB já havia registrado o comando global em seu próprio ciclo de carregamento.
- **Estagio do Factorio:** runtime
- **Uso no projeto:** Todo o runtime (`control.lua`, `control/functions.lua`, `control/handle.lua`, `control/portal.lua`, `control/gui/portal-gui.lua`, `control/utils/portal-network.lua`)
- **Implementacao temporaria:** `control/utils/lda-runtime.lua` (importa diretamente os submódulos `player`, `entity`, `world` e `item` sem disparar `commands.register()`)
- **Compatibilidade:** LDA-LIB >= 0.0.16, Factorio 2.1+
- **Observacoes:** A tabela de comandos do Factorio (`commands.add_command`) é compartilhada globalmente entre todos os mods. Métodos de inicialização de comandos de biblioteca devem ser idempotentes ou restritos ao mod que os define.
