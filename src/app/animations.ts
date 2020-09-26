import {
  trigger,
  transition,
  style,
  query,
  animateChild,
  group,
  animate,
} from '@angular/animations';

export const opacityAnimations =
  trigger('routeAnimations', [
    transition('workshop <=> dashboard', [
      query(':enter, :leave', [
        style({
          opacity: 0.5
        })
      ]),
      group([
        query(':leave', [
          animate('300ms ease-out', style({ opacity: 0 }))
        ]),
        query(':enter', [
          animate('300ms ease-out', style({ opacity: 1 }))
        ])
      ]),
      query(':enter', animateChild()),
    ]),
  ]);
