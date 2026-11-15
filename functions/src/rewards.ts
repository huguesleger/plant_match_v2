export const TRANSACTION_LEAVES = 2;
export const TRANSACTION_POINTS = 1;
export const CONTACT_COST = 1;
export const REFERRAL_SPONSOR_BONUS = 2;
export const REFERRAL_REFEREE_BONUS = 1;
export const REFERRAL_FIRST_TRANSACTION_BONUS = 3;

const REQUIRED_POINTS: Record<number, number> = {
  1: 0,
  2: 2,
  3: 5,
  4: 10,
  5: 25,
  6: 50,
  7: 100,
};

export const levelForPoints = (points: number): number =>
  Object.keys(REQUIRED_POINTS)
    .map(Number)
    .filter((level) => points >= REQUIRED_POINTS[level])
    .reduce((best, level) => Math.max(best, level), 1);

export interface PointsUpdate {
  uid: string;
  previousLevel: number;
  level: number;
  currentPoints: number;
  bonusLeaves: number;
  giftedLeaves: number;
}

export const computeUpdate = (
  uid: string,
  current: {currentPoints?: number; level?: number} | undefined,
  pointsToAdd: number,
  giftedLeaves: number,
): PointsUpdate => {
  const previousPoints = current?.currentPoints ?? 0;
  const previousLevel = current?.level ?? levelForPoints(previousPoints);
  const currentPoints = Math.max(0, previousPoints + pointsToAdd);
  const level = Math.max(previousLevel, levelForPoints(currentPoints));
  return {
    uid,
    previousLevel,
    level,
    currentPoints,
    bonusLeaves: 0,
    giftedLeaves,
  };
};
