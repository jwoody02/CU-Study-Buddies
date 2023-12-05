//
//  HomeViewController.swift
//  CU Study Buddies
//
//  Created by Jordan Wood on 12/5/23.
//

import Foundation
import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var collectionView: UICollectionView!
    var studySessions: [StudySession] = []

    let filterButton = UIButton(type: .system)
    let searchButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()

        setBackgroundToGrain()
        setupButtons()
        setupCollectionView()
        fetchStudySessions()
    }

    private func setupButtons() {
        // Configure filterButton
        filterButton.setTitle("Filter", for: .normal)
        filterButton.tintColor = UIColor(red: 197/255.0, green: 178/255.0, blue: 118/255.0, alpha: 1.0)
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)

        // Configure searchButton with a magnifying glass icon
        let magnifyingGlassImage = UIImage(systemName: "magnifyingglass")
        searchButton.setImage(magnifyingGlassImage, for: .normal)
        searchButton.tintColor = UIColor(red: 197/255.0, green: 178/255.0, blue: 118/255.0, alpha: 1.0)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)

        // Add buttons to the view and set constraints
        view.addSubview(filterButton)
        view.addSubview(searchButton)

        filterButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            filterButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),

            searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }


    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear

        collectionView.register(TAStudySessionCell.self, forCellWithReuseIdentifier: "TAStudySessionCell")
        collectionView.register(StudentStudySessionCell.self, forCellWithReuseIdentifier: "StudentStudySessionCell")

        view.addSubview(collectionView)

        // Update collection view constraints
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 10),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func fetchStudySessions() {
        // Fetch study sessions and reload the collection view
        // This is where you would integrate with your data fetching logic
        StudySessionManager.shared.fetchStudySessions { [weak self] sessions in
            // weak self to avoid memory leaks
            self?.studySessions = sessions
            self?.collectionView.reloadData()
        }
        
    }

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2 // One for TA, one for students
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Split the data based on organizer type
        let taSessions = studySessions.filter { $0.organizer.type == .TA }
        let studentSessions = studySessions.filter { $0.organizer.type == .Student }

        return section == 0 ? taSessions.count : studentSessions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let taSessions = studySessions.filter { $0.organizer.type == .TA }
        let studentSessions = studySessions.filter { $0.organizer.type == .Student }

        if indexPath.section == 0 {
            // TA section
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TAStudySessionCell", for: indexPath) as! TAStudySessionCell
            cell.configure(with: taSessions[indexPath.row])
            return cell
        } else {
            // Student section
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StudentStudySessionCell", for: indexPath) as! StudentStudySessionCell
            cell.configure(with: studentSessions[indexPath.row])
            return cell
        }
    }

    // MARK: UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            // Size for TA session cells (horizontal)
            return CGSize(width: 200, height: 100)
        } else {
            // Size for student session cells (vertical)
            return CGSize(width: collectionView.bounds.width, height: 100)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    // MARK: Button Actions

   @objc private func filterButtonTapped() {
       // Implement filter logic
   }

   @objc private func searchButtonTapped() {
       // Implement search logic
   }
}

extension UICollectionViewCell {
    func createInitialsImage(for name: String, backgroundColor: UIColor) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = backgroundColor
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 40)
        nameLabel.text = name.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first!)" }
        nameLabel.layer.cornerRadius = frame.size.width / 2
        nameLabel.layer.masksToBounds = true

        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        return nil
    }

}

class TAStudySessionCell: UICollectionViewCell {
    private let profileImageView = UIImageView()
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCell()
    }

    private func setupCell() {
        // Configure cell appearance
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .white
        

        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 12
        self.layer.cornerRadius = 12
        self.layer.shadowOpacity = 0.1
        
        self.contentView.layer.cornerRadius = 12
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 12
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        self.layer.masksToBounds = false
        self.clipsToBounds = true

        // Profile image view setup
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: 60),
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        profileImageView.layer.cornerRadius = 30
        profileImageView.clipsToBounds = true

        // Title label setup
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        titleLabel.numberOfLines = 0
        titleLabel.font = ComfortaaFont.bold.font(size: FontSizeManager.fontSize(for: .body) - 2)
    }

    func configure(with session: StudySession) {
        titleLabel.text = session.title
        if let image = createInitialsImage(for: session.organizer.name, backgroundColor: randomColor()) {
            profileImageView.image = image
        }
    }

    private func randomColor() -> UIColor {
        return UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
    }
}

class StudentStudySessionCell: UICollectionViewCell {
    private let profileImageView = UIImageView()
    private let titleLabel = UILabel()
    private let bodyContentLabel = UILabel()
    private let detailsLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCell()
    }

    private func setupCell() {
        // Configure cell appearance
        backgroundColor = .clear
        contentView.backgroundColor = .white
//        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 12
        layer.shadowOpacity = 0.1
        layer.masksToBounds = false
        clipsToBounds = true

        // Profile image view setup
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        profileImageView.layer.cornerRadius = 25
        profileImageView.clipsToBounds = true

        // Title label setup
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        titleLabel.font = ComfortaaFont.bold.font(size: FontSizeManager.fontSize(for: .body) - 2)

        // Body content label setup
        bodyContentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bodyContentLabel)
        bodyContentLabel.numberOfLines = 0
        bodyContentLabel.textColor = .lightGray
        bodyContentLabel.font = ComfortaaFont.regular.font(size: FontSizeManager.fontSize(for: .caption))
        NSLayoutConstraint.activate([
            bodyContentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            bodyContentLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            bodyContentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        // Configure bodyContentLabel as needed, e.g., font, color

        // Details label setup
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(detailsLabel)
        NSLayoutConstraint.activate([
            detailsLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            detailsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            detailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        detailsLabel.font = ComfortaaFont.regular.font(size: FontSizeManager.fontSize(for: .body) - 2)
        detailsLabel.textColor = .gray
    }

    func configure(with session: StudySession) {
        titleLabel.text = session.title
        detailsLabel.text = "Class: \(session.classInfo) - Attendees: \(session.attendees.count)"
        if let image = createInitialsImage(for: session.classInfo, backgroundColor: randomColor()) {
            profileImageView.image = image
        }
        bodyContentLabel.text = session.bodyContent
    }

    private func randomColor() -> UIColor {
        return UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
    }
}
