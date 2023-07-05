import Foundation

protocol DomainModelMapper {
    associatedtype domainModel
    associatedtype entityModel

    static func mapToDomainModel(from entity: entityModel) -> domainModel
    static func mapToEntity(from domain: domainModel, entity: inout entityModel)
}
