import { Injectable } from '@nestjs/common';

/**
 * Default service providing application logic.
 */
@Injectable()
export class AppService {
  getHello(): string {
    return 'Hello World!';
  }
}
