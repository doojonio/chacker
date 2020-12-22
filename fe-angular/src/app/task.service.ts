import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { retry, tap } from 'rxjs/operators';
import { Task } from './entities/challenge-common';
import { environment } from '../environments/environment';

@Injectable({
  providedIn: 'root',
})
export class TaskService {
  private updateUrl = environment.backendUrl + '/api/task';

  constructor(private http: HttpClient) {}

  public update(taskId: number, fields: any): Observable<Task> {
    return this.http.put<Task>(this.updateUrl + `/${taskId}`, fields);
  }
}
