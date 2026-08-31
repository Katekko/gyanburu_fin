# Caju benefit wallets (manual tracking)

O João recebe benefícios Caju do Grupo Boticário em três carteiras: Refeição,
Alimentação e Home Office. A Caju **não exporta OFX**, então o tracking é
100% manual. Regra de uso: toda comida sai do Caju (categorias 14 Mantimentos
e 15 Fastfood).

## Decisões de modelagem (31/08/2026, com o João)

- **Duas carteiras no app**, não três: `comida` (Refeição + Alimentação
  juntas — João não quis separar) e `home-office`. Recargas mensais reais:
  R$ 880 + R$ 610 = R$ 1.490 (comida) e R$ 150 (home office).
- **Lançamentos vivem em `financial_transaction`** (mesma tabela do OFX), com
  `walletId` apontando para `benefit_wallet`, `source: 'caju'` e
  `kind: 'expense' | 'topup'`. Valores sempre **positivos** — a direção vai no
  `kind`, seguindo a convenção do import OFX. Com isso os gastos do Caju
  aparecem de graça na aba Transactions, no dashboard por categoria e nas
  regras de categoria por estabelecimento.
- **Recarga manual** (sem lançamento automático mensal): valor/dia podem
  variar. Cada carteira guarda um `monthlyTopupAmount` opcional usado como
  default do comando/dialog de recarga.
- **Carteira sempre explícita** nos lançamentos — sem inferência por
  categoria.

## Saldo por âncora

`BenefitWallet` guarda `anchorBalance` + `anchorDate`: um saldo sabidamente
correto naquele instante. Saldo atual = âncora + topups − gastos com
`occurredAt` estritamente posterior à âncora. Reconciliar com o app da Caju é
só mover a âncora (`caju-set-balance`) — o histórico fica intacto. As
carteiras são criadas lazy (âncora 0 em 1970) no primeiro uso por usuário.

## Superfícies

- **Server**: `WalletEndpoint` (`wallet`) — `summaries`, `monthTransactions`,
  `spend`, `topup`, `setBalance`, `setMonthlyTopup`, `deleteTransaction`.
- **CLI**: `gyanburu caju [YYYY-MM]`, `caju-spend`, `caju-topup`,
  `caju-set-balance`, `caju-set-topup`, `caju-delete` (`--wallet comida|home-office`,
  `home` aceito como atalho).
- **Flutter**: tela "Caju" no rail (cards por carteira + lançamentos do mês,
  dialogs de gasto/recarga/reconciliação) e chip/badge "Caju" no histórico de
  transações.

Nos agregados existentes, `kind: 'topup'` é informativo: excluído de
despesas, receitas e da contagem de "uncategorized" (dashboard, histórico e
CLI `uncategorized`).

## Migração 20260831182936216

O `migration.sql` gerado foi editado à mão para **remover os DROPs das
tabelas `serverpod_auth_*`** — elas foram deixadas no banco de propósito no
commit d444e70 (drop é irreversível). Como o `definition.json` desta migração
já não as contém, migrações futuras não tentarão dropá-las de novo.

## Bootstrap dos dados do João (rodar uma vez, contra produção)

```
gyanburu caju-set-balance --wallet comida --amount 1426.94 --date 2026-08-31
gyanburu caju-set-balance --wallet home --amount 807.02 --date 2026-08-31
gyanburu caju-set-topup --wallet comida --amount 1490
gyanburu caju-set-topup --wallet home --amount 150
```

(Saldos reais em 31/08/2026: Refeição 859,48 + Alimentação 567,46 = 1.426,94;
Home Office 807,02.)
