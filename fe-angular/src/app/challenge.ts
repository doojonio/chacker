import { Task } from './task';

export class Challenge {
    id: number;
    title: number;
    description: number;
    tasks: Task[];
    state: ChallengeStates;
}

export enum ChallengeStates {
    inProgress = 'in progress',
    completed = 'completed',
    new = 'new',
    failed = 'failed',
}