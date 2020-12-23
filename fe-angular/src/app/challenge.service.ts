import { Observable, of } from 'rxjs';
import { catchError, switchMap, tap } from 'rxjs/operators';

import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';

import { environment } from '../environments/environment';
import { Challenge } from './challenge';

@Injectable({
  providedIn: 'root',
})
export class ChallengeService {
  constructor(private _http: HttpClient) {}

  list(): Observable<Challenge[]> {
    const listUrl = environment.backendUrl + '/api/challenge';
    return this._http.get<Challenge[]>(listUrl);
  }

  getById(id: number): Observable<Challenge> {
    const getUrl = environment.backendUrl + `/api/challenge`;
    const params = new HttpParams();
    params.set('id', id.toString());
    return this._http
      .get<Challenge[]>(getUrl, { params })
      .pipe(
        catchError((error) => {
          console.log(error);
          return of([null]);
        }),
        switchMap((challenges) => {
          return of(challenges[0]);
        })
      );
  }
}
