import { Injectable } from '@nestjs/common';
import { Connection } from 'typeorm';
import { InjectConnection } from '@nestjs/typeorm';

@Injectable()
export class AppService {
  constructor(
    @InjectConnection()
    private connection: Connection,
  ) {}

  async getHello(): Promise<string> {
    const response = await this.connection.query(
        'SELECT version()',
    )

    return `Hello World! PG Version: ${response[0].version}`;
  }
}
