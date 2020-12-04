import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { retry } from 'rxjs/operators';
import { Challenge } from './entities/challenge-common';
import { environment } from '../environments/environment';

@Injectable({
  providedIn: 'root',
})
export class ChallengeService {
  listUrl = environment.backendUrl + '/api/challenge';
  createUrl = environment.backendUrl + '/api/challenge';

  constructor(private http: HttpClient) {}

  public list(): Observable<Challenge[]> {
    return this.http.get<Challenge[]>(this.listUrl).pipe(retry(3));
  }

  public createChallenge(challenge: Challenge) {
    return this.http.post<any>(this.createUrl, challenge);
  }
}
