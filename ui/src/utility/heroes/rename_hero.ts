import { Transaction } from "@mysten/sui/transactions";

export const renameHero = (
  packageId: string,
  heroId: string,
  newName: string
) => {
  const tx = new Transaction();

  tx.moveCall({
    target: `${packageId}::hero::rename_hero`,
    arguments: [tx.object(heroId), tx.pure.string(newName)],
  });

  return tx;
};


