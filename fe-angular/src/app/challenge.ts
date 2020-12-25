import { Task } from './task';

export class Challenge {
  id: number;
  title: number;
  description: number;
  tasks: Task[];
  state: ChallengeStates;
  picture: string | number;
  pictureUrl: string;

  createTime: string;
  changeTime: string;

  // ---
  // snakecase fields from webservices (added for compatibility)
  // ---
  create_time: string;
  change_time: string;
  // ---
}

export enum ChallengeStates {
  inProgress = 'in progress',
  completed = 'completed',
  new = 'new',
  failed = 'failed',
}
