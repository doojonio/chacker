import { Component, OnInit, Input } from '@angular/core';
import { Task } from '../../entities/challenge-common';

@Component({
  selector: 'app-task-list',
  templateUrl: './task-list.component.html',
  styleUrls: ['./task-list.component.sass']
})
export class TaskListComponent implements OnInit {
  @Input() tasks: Task[];
  displayedColumns: string[] = [
    'title',
  ];

  constructor() { }

  ngOnInit(): void {
  }

}
