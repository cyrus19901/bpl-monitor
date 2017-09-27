protocol RequestListener: class {
    func onFailure(e: Error)
    func onResponse(object: Any)
}
