import { Component, OnInit } from '@angular/core';
import { ChallengeService } from '../challenge.service';
import { Challenge } from '../entities/challenge-common';

import { Subscription } from 'rxjs';
import { Apollo, gql } from 'apollo-angular';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.sass']
})
export class DashboardComponent implements OnInit {
  challenges: Challenge[];
  isLoading: boolean = true;

  constructor(
    private challengeService: ChallengeService,
    private apollo: Apollo,
  ) { }

  ngOnInit(): void {
    this.apollo.watchQuery<any>({
      query: gql`
        query {
          searchChallenge (
            input: {
              title: "qweqwe"
            }
          ) {
            id
            title
            description
            tasks {
              id
              title
              type
            }
          }
        }
      `,
    }).valueChanges.subscribe(({data, loading}) => {
      console.log(data);
      this.challenges = data.searchChallenge;
      this.isLoading = loading;
    });
  }

  showDetails(challengeId: number) {
  }
}
