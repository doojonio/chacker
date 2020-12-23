export class Task {
    id: number;
    title: string;
    description: string;
    state: TaskStates;
}

export enum TaskStates {
    inProgress = 'in progress',
    completed = 'completed',
    new = 'new',
    failed = 'failed',
}
