import { Observable, of, throwError } from 'rxjs';
import { catchError, tap } from 'rxjs/operators';

import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';

import { environment } from '../environments/environment';
import { Challenge, ChallengeDto, ChallengeDtoFields } from './challenge';
import { pick } from './pick';
import { TaskDto, TaskDtoFields } from './task';

@Injectable({
  providedIn: 'root',
})
export class ChallengeService {
  constructor(private _http: HttpClient) {}

  create(challenge: Challenge) {
    let dataTransferObject = pick(challenge, ChallengeDtoFields) as ChallengeDto;
    dataTransferObject.tasks = challenge.tasks.map(task => {
      return pick(task, TaskDtoFields) as TaskDto;
    });

    const urlForCreating = environment.backendUrl + '/api/challenge';
    return this._http.post<Challenge>(urlForCreating, dataTransferObject).pipe(
      catchError(err => {
        console.log(err);
        console.log(dataTransferObject);
        return throwError(err);
      }),
    );
  }

  list(): Observable<Challenge[]> {
    const listUrl = environment.backendUrl + '/api/challenge';
    return this._http.get<Challenge[]>(listUrl);
  }

  getById(id: number): Observable<Challenge> {
    const getUrl = environment.backendUrl + `/api/challenge/${id}`;
    return this._http.get<Challenge>(getUrl).pipe(
      tap((challenge) => {
        this._fixSnakecaseFields(challenge);
        this._addPictureUrls(challenge);
      }),
      catchError((error) => {
        console.log(error);
        return of(null);
      })
    );
  }

  private _addPictureUrls(challenge: Challenge): void {
    challenge.pictureUrl =
      environment.staticStorageUrl + challenge.picture.path;
    challenge.tasks.forEach((task) => {
      task.pictureUrl = environment.staticStorageUrl + task.picture.path;
    });
  }

  // FIXME #4 need common solution for snakecase fields
  private _fixSnakecaseFields(challenge: Challenge): void {
    challenge.changeTime = challenge.change_time;
    challenge.createTime = challenge.create_time;
    challenge.tasks.forEach((task) => {
      task.createTime = task.create_time;
      task.changeTime = task.change_time;
    });
  }
}
