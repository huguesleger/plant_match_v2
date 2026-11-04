export const MAX_LEVEL = 7;
export const PLANT_GIVEN_LEAVES = 2;
export const CONTACT_COST = 1;
export const REFERRAL_BONUS = 3;

const REQUIRED_POINTS: Record<number, number> = {
  1: 0,
  2: 2,
  3: 5,
  4: 10,
  5: 25,
  6: 50,
  7: 100,
};

const LEVEL_UP_LEAVES: Record<number, number> = {
  2: 3,
  3: 5,
  4: 8,
  5: 12,
  6: 20,
  7: 0,
};

export const levelForPoints = (points: number): number =>
  Object.keys(REQUIRED_POINTS)
    .map(Number)
    .filter((level) => points >= REQUIRED_POINTS[level])
    .reduce((best, level) => Math.max(best, level), 1);

export const bonusLeavesBetween = (from: number, to: number): number =>
  Array.from({length: Math.max(0, to - from)}, (_, i) => from + i + 1)
    .map((level) => LEVEL_UP_LEAVES[level] ?? 0)
    .reduce((sum, bonus) => sum + bonus, 0);

export const hasUnlimitedContacts = (level: number): boolean =>
  level >= MAX_LEVEL;

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
    bonusLeaves: bonusLeavesBetween(previousLevel, level),
    giftedLeaves,
  };
};
