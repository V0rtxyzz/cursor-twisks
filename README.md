# Cursor Twisks

Script de personalização de cursor e correção de limite de tela/câmera para Roblox, com interface própria.

## Funcionalidades

- **Personalização de Cursor**: aplica um cursor customizado via ID de Decal, com controle de tamanho (12–100px) e botão de restaurar padrão.
- **Correção de Limite de Tela**: ajusta o comportamento da câmera para evitar restrições de tela em determinados jogos.
- **Sensibilidade**: slider de 0 a 100% que controla a sensibilidade do mouse (`UserInputService.MouseDeltaSensitivity`).
- **Trava de câmera**:
  - `CapsLock` alterna uma trava fixa (liga/desliga).
  - Botão direito do mouse mantém o comportamento padrão do Roblox.
- **Menu**: abre e fecha com `F5`, ou pelo botão **×** no canto do painel.
- Aviso rápido no canto inferior direito ao carregar, confirmando que a correção de tela está ativa.

## O que NÃO tem

Sem ESP, sem speed hack, sem jump hack, sem `loadstring` de terceiros embutido no código — só o essencial de personalização.

## Como instalar

1. Abra seu executor de scripts Roblox (ex: Delta, Arceus X, Hydrogen, ou outro de sua preferência).
2. Entre no jogo onde deseja usar o script.
3. Cole o código abaixo na caixa de execução do executor:

```
loadstring(game:HttpGet("https://raw.githubusercontent.com/V0rtxyzz/cursor-twisks/refs/heads/main/cursortwisks-1.lua"))()
```

4. Clique em **Execute**.
5. Pressione `F5` para abrir o painel de personalização do cursor. O ajuste de tela/câmera já fica ativo automaticamente.

## Onde pegar IDs de cursor

Para usar a função de personalização, você precisa do **ID do Decal** da imagem que quer usar como cursor. Você pode encontrar imagens prontas na loja do Roblox Creator Hub:

🔗 https://create.roblox.com/store/category/2d?keyword=cursor

Ao abrir uma imagem lá, copie o número que aparece na URL da página (ou no botão de "Asset ID") e cole na caixa de texto do painel do Cursor Twisks.

## Créditos

- **Cursor Twisks** — desenvolvido por **claudtxyz**
- Baseado na ideia original do **MOBHUB**, projeto de **MODARO & LUCAS** (`@MODARORX` & `@luczx_v7`) — este script é uma reconstrução independente, mantendo apenas as funções de personalização de cursor e correção de tela, sem os recursos de ESP, speed hack e jump hack do projeto original.
- Discord da comunidade original do MOBHUB: https://discord.gg/NXBhWkRQpM
