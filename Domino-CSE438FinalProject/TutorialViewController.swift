//
//  TutorialViewController.swift
//  Domino-CSE438FinalProject
//
//  Created by Jeanette Rovira on 8/1/21.
//

import UIKit

class TutorialViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var label: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
        label.numberOfLines = 0
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus molestie leo vitae fringilla congue. Suspendisse dignissim vel massa a commodo. Donec convallis convallis velit, nec sollicitudin ex sodales ut. Donec feugiat porta feugiat. Morbi molestie faucibus pellentesque. Morbi faucibus neque nec mi maximus, a auctor nibh consectetur. Sed eget odio et massa consectetur varius. Curabitur tempor urna in neque tristique ultricies. Aenean nec nibh augue. Nunc mollis auctor bibendum. \n Maecenas placerat ultricies justo, quis pretium ex ultricies id. Interdum et malesuada fames ac ante ipsum primis in faucibus. Curabitur ac est ac magna sagittis tempor ac laoreet mauris. Sed ac viverra ligula. Nulla sed diam mi. Sed ultricies urna vitae ex volutpat interdum. Mauris sit amet purus leo. Nunc congue dapibus commodo. Pellentesque ante lacus, tincidunt non est convallis, egestas tincidunt tortor. Suspendisse pellentesque eget purus eu pharetra. Nam sit amet arcu tempus, tincidunt eros quis, volutpat mi. Maecenas vestibulum, mi vitae porta placerat, nisi massa venenatis ipsum, et tincidunt arcu nulla vitae quam. Quisque venenatis rutrum nisi ac elementum. Cras convallis, sapien a tincidunt iaculis, velit nisi scelerisque erat, vitae varius mauris lacus quis mi. Donec commodo efficitur nulla, a dapibus massa tristique vitae. Nunc semper malesuada ante quis ultricies. \n Aenean consequat diam sit amet turpis volutpat, eget tempor mi ultricies. Curabitur posuere ut quam eu iaculis. Interdum et malesuada fames ac ante ipsum primis in faucibus. Curabitur sed tellus mollis, ultrices tortor a, ultrices est. Aliquam sit amet fringilla neque. Sed vulputate malesuada mi. In efficitur facilisis nulla, quis tincidunt felis fermentum et. Nam ut sodales dolor. Etiam consequat placerat semper. Pellentesque vestibulum quam justo, sit amet iaculis erat tempor a. Quisque luctus congue neque vitae dapibus. Vestibulum lacus justo, tempus nec ante id, aliquet fringilla ligula. \n Quisque malesuada luctus mauris ut pharetra. Aliquam sed sapien molestie, laoreet ex eu, sodales nisl. Vestibulum faucibus risus pulvinar, rutrum lacus at, feugiat mauris. Pellentesque vehicula congue malesuada. Nam placerat sapien sed lorem vestibulum aliquam. Proin nulla metus, egestas eu ornare eget, elementum pellentesque nunc. Nam nec maximus sem, in tristique arcu. Nunc pretium laoreet porttitor. Integer pellentesque turpis odio, nec dapibus nibh blandit sit amet. Donec eget purus vehicula, venenatis erat non, consectetur diam. Vestibulum eu fringilla magna. Sed at tellus at metus rutrum pellentesque volutpat non ipsum. Mauris sodales turpis eget ex posuere pharetra. Pellentesque ut enim urna. Nam sollicitudin, dolor vel semper lobortis, augue diam ultricies nisi, non auctor est justo vitae enim. Nunc sit amet luctus dolor. \n Sed condimentum dui erat, vel mattis sem iaculis nec. Aenean sit amet elit non eros efficitur consectetur tempor eu massa. Vestibulum quis felis aliquet, aliquam augue quis, tempus erat. Integer nec auctor lectus, sed dignissim eros. Phasellus ac diam tortor. Quisque et lectus scelerisque, condimentum nisi"
    }


}
