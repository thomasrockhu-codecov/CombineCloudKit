//
//  CKContainer.swift
//  CombineCloudKit
//
//  Created by Chris Araman on 2/18/21.
//  Copyright © 2021 Chris Araman. All rights reserved.
//

import CloudKit
import Combine

extension CKContainer {
  private func publisherFrom<Output>(
    _ method: @escaping (@escaping (Output, Error?) -> Void) -> Void
  ) -> AnyPublisher<Output, Error> {
    Future { promise in
      method { item, error in
        guard error == nil else {
          promise(.failure(error!))
          return
        }

        promise(.success(item))
      }
    }.eraseToAnyPublisher()
  }

  public final func accountStatus() -> AnyPublisher<CKAccountStatus, Error> {
    publisherFrom(accountStatus)
  }
}
