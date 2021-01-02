export function pick<T>(obj: T, keys: string[]): Object {
  const copy = new Object();
  keys.filter((key) => key in obj).forEach((key) => (copy[key] = obj[key]));
  return copy;
}
