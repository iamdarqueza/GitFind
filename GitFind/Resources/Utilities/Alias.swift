//
//  Alias.swift
//  GitFind
//
//  Created by Danmark Arqueza on 10/11/21.
//

import Foundation


// Empty result
typealias EmptyResult<ReturnType> = () -> ReturnType

// Custom result
typealias SingleResultWithReturn<T, ReturnType> = ((T) -> ReturnType)

// Custom result
typealias SingleResult<T> = SingleResultWithReturn<T, Void>
typealias OnCompletionHandler<T> = ((T?, Error?) -> Void)
typealias ResultClosure<T> = ((T?, Bool, String?) -> Void)
typealias VoidResult = EmptyResult<Void>
