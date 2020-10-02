//-- All about challenge -----
export enum challengeState {
  completed = 'completed',
  new = 'new',
  inProgress = 'in progress',
  failed = 'failed',
}

export class Challenge {
  title: string;
  description: string;
  state: challengeState;

  tasks: Task[];
};

//-- All about task -----

export enum taskState {
  completed = 'completed',
  new = 'new',
  inProgress = 'in progress',
  failed = 'failed',
}

export enum taskType {
  once = 'once',
  days = 'days',
}

export class Task {
  title: string;
  type: taskType;
};
