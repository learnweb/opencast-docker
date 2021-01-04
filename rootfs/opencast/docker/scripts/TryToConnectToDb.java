// Copyright 2016 The WWU eLectures Team All rights reserved.
//
// Licensed under the Educational Community License, Version 2.0
// (the "License"); you may not use this file except in compliance with
// the License. You may obtain a copy of the License at
//
//     http://opensource.org/licenses/ECL-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Console application that tries multiple times to connect to a JDBC URL.
 */
public class TryToConnectToDb {
  private static final int SLEEP_TIME = 5 * 1000;

  public static void main(String[] args) throws InterruptedException {
    if (args.length != 5) {
      System.err.println("Wrong number of arguments provided");
      printUsage();
      System.exit(1);
    }

    final String
        driver = args[0],
        url = args[1],
        user = args[2],
        password = args[3];
    final int numberOfTries = Integer.parseInt(args[4]);

    // 1. Check if driver is available
    try {
      Class.forName(driver);
    } catch (ClassNotFoundException e) {
      System.err.println("Driver could not be found");
      System.exit(1);
    }

    // 2. Try to connect to DB
    Connection conn = null;
    boolean failed = true;
    for (int i = 1; failed && i <= numberOfTries; i++) {
      failed = false;
      try {
        System.out.print("Try to connect to DB (" + i + "/" + numberOfTries + ") ");
        conn = DriverManager.getConnection(url, user, password);
      } catch (SQLException e) {
        failed = true;
        System.out.println("FAILED");
      } finally {
        if (conn != null) {
          try {
            conn.close();
          } catch (Exception e) {
            // ignore
          }
        }
      }

      if (failed && i < numberOfTries) {
        Thread.sleep(SLEEP_TIME);
      } else if (!failed) {
        System.out.println("SUCCEEDED");
      }
    }

    if (failed) {
      System.err.println("Could not connect to DB");
      System.exit(1);
    }
  }

  private static void printUsage() {
    System.out.println("Usage: java TryToConnectToDb DRIVER URL USER PASSWORD NUMBER_OF_TRIES");
  }
}
