import { Observable } from 'rxjs';

import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';

import { environment } from '../environments/environment';
import { Challenge } from './challenge';

@Injectable({
  providedIn: 'root'
})
export class ChallengeService {

  constructor(
    private _http: HttpClient,
  ) { }

  list(): Observable<Challenge[]> {
    const listUrl = environment.backendUrl + "/api/challenge";
    return this._http.get<Challenge[]>(listUrl)
  }
}
