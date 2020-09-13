import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Challenge } from './entities/challenge-common';

@Injectable({
  providedIn: 'root'
})
export class ChallengeService {

  constructor(
    private http: HttpClient,
  ) { }

  public list(): Observable<Challenge[]> {
    return this.http.get<Challenge[]>('http://localhost:3000/api/challenge');
  }

  public createChallenge(challenge :Challenge) {
    return this.http.post<any>('http://localhost:3000/api/challenge', challenge);
  }
}
