//
//  ChatRoomVC.swift
//  ChatApp
//
//  Created by Aboody on 05/08/2021.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Gallery
import RealmSwift

class ChatRoomVC: MessagesViewController {
    
    //MARK: - Views
    let leftBarButtonView: UIView = {
        return UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    }()
    let titleLabel: UILabel = {
        let title = UILabel(frame: CGRect(x: 5, y: 0, width: 180, height: 25))
        title.textAlignment = .left
        title.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        title.adjustsFontSizeToFitWidth = true
        return title
    }()
    let subTitleLabel: UILabel = {
        let subTitle = UILabel(frame: CGRect(x: 5, y: 22, width: 180, height: 20))
        subTitle.textAlignment = .left
        subTitle.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        subTitle.adjustsFontSizeToFitWidth = true
        return subTitle
    }()
    
    
    //MARK: - Vars
    private var chatId = ""
    private var recipientId = ""
    private var recipentName = ""
    
    var mkMessages: [MKMessage] = []
    var allLocalMessages: Results<LocalMessage>!
    
    var displayingMessagesCount = 0
    var maxMessageNumber = 0
    var minMessageNumber = 0
    
    var typingCounter = 0
    
    var galllery: GalleryController!
    
    //Listeners
    var notificationToken: NotificationToken?
    
    var longPressGesture: UILongPressGestureRecognizer!
    var audioFileName = ""
    var audioDuration: Date!
    
    open lazy var audioController = BasicAudioController(messageCollectionView: messagesCollectionView)
    
    
    //MARK: - Constants
    private let refreshController = UIRefreshControl()
    let micButton = InputBarButtonItem()
    let currentUser = MKSender(senderId: User.currentId, displayName: User.currentUser!.username)
    let realm = try! Realm()
    
    //MARK: - Inits
    init(chatId: String, recipientId: String, recipentName: String) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.chatId = chatId
        self.recipientId = recipientId
        self.recipentName = recipentName
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        createTypingObserver()
        configureMessageCollectionView()
        configureGestureRecognizer()
        configureMessageInputBar()
        
        configureLeftBarButton()
        configureCustomTitle()
        
        loadChats()
        listenForNewChats()
        listenForReadStatusChange()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        FirebaseRecentListener.shared.resetRecentCounter(chatRoomId: chatId)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        FirebaseRecentListener.shared.resetRecentCounter(chatRoomId: chatId)
        audioController.stopAnyOngoingPlaying()
    }
    
    //MARK: - UpdateReadMessageStatus
    private func updateMessage(_ localMessage: LocalMessage) {
        
        for index in 0 ..< mkMessages.count {
            
            let tempMessage = mkMessages[index]
            
            if localMessage.id == tempMessage.messageId {
                mkMessages[index].status = localMessage.status
                mkMessages[index].readDate = localMessage.readDate
                
                RealmManager.shared.saveToRealm(localMessage)
                
                if mkMessages[index].status == kREAD {
                    self.messagesCollectionView.reloadData()
                }
            }
        }
    }
    
    //MARK: - Helpers Functions
    private func configureMessageCollectionView() {
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        
        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        
        messagesCollectionView.refreshControl = refreshController
    }
    
    private func configureGestureRecognizer() {
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.recordAudio))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delaysTouchesBegan = true
    }
    
    private func configureMessageInputBar() {
        
        messageInputBar.delegate = self
        
        let attachButton = InputBarButtonItem()
        attachButton.image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        attachButton.setSize(CGSize(width: 30, height: 30), animated: false)
        attachButton.onTouchUpInside { item in
            self.actionAttachMessage()
        }
        
        micButton.image = UIImage(systemName: "mic.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        micButton.setSize(CGSize(width: 30, height: 30), animated: false)
        micButton.addGestureRecognizer(longPressGesture)
        
        messageInputBar.setStackViewItems([attachButton], forStack: .left, animated: false)
        updateMicButtonStatus(show: true)
        
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.inputTextView.isImagePasteEnabled = false
        messageInputBar.backgroundView.backgroundColor = .systemBackground
        messageInputBar.inputTextView.backgroundColor = .systemBackground
    }
    
    func updateMicButtonStatus(show: Bool) {
        
        if show {
            messageInputBar.setStackViewItems([micButton], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 30, animated: false)
        } else {
            messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 55, animated: false)
        }
    }
    
    private func configureLeftBarButton() {
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(self.backButtonPressed))]
    }
    
    private func configureCustomTitle() {
        
        leftBarButtonView.addSubview(titleLabel)
        leftBarButtonView.addSubview(subTitleLabel)
        
        let leftBarButtonItem = UIBarButtonItem(customView: leftBarButtonView)
        self.navigationItem.leftBarButtonItems?.append(leftBarButtonItem)
        
        titleLabel.text = recipentName
    }
    
    private func lastMessageDate() -> Date {
        
        let lastMessageDate = allLocalMessages.last?.date ?? Date()
        
        return Calendar.current.date(byAdding: .second, value: 1, to: lastMessageDate) ?? lastMessageDate
    }
    
    private func removeListeners() {
        FirebaseTypingListener.shared.removeTypingListener()
        FirebaseMassageListener.shared.removeListeners()
    }
    
    //MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshController.isRefreshing {
            if displayingMessagesCount < allLocalMessages.count {
                
                self.loadMoreMessage(maxNumber: maxMessageNumber, minNumber: minMessageNumber)
                messagesCollectionView.reloadDataAndKeepOffset()
            }
            refreshController.endRefreshing()
        }
    }
    
    //MARK: - Load Chats
    private func loadChats() {
        
        let predicate = NSPredicate(format: "chatRoomId = %@", chatId)
        allLocalMessages = realm.objects(LocalMessage.self).filter(predicate).sorted(byKeyPath: kDATE, ascending: true)
        
        if allLocalMessages.isEmpty {
            checkForOldChats()
        }
        
        notificationToken = allLocalMessages.observe({ (changes: RealmCollectionChange) in
            
            switch changes {
            
            //updated message
            case .initial:
                self.insertMessages()
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem(animated: true)
            case .update(_, _, let insertions, _):
                
                for index in insertions {
                    
                    self.insertMessage(self.allLocalMessages[index])
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToLastItem(animated: false)
                }
                
            case .error(let error):
                print("Error on new insertion ", error.localizedDescription)
            }
            
        })
        
    }
    
    private func listenForNewChats() {
        FirebaseMassageListener.shared.listenForNewChats(User.currentId, collectionId: chatId, lastMessageDate: lastMessageDate())
    }
    
    private func checkForOldChats() {
        FirebaseMassageListener.shared.checkForOldChats(User.currentId, collectionId: chatId)
    }
    
    //MARK: - Insert Messages
    private func listenForReadStatusChange() {
        
        FirebaseMassageListener.shared.listenForReadStatusChange(User.currentId, collectionId: chatId) { (updatedMessage) in
            if updatedMessage.status != kSENT {
                self.updateMessage(updatedMessage)
            }
        }
    }
    
    private func insertMessages() {
        
        maxMessageNumber = allLocalMessages.count - displayingMessagesCount
        minMessageNumber = maxMessageNumber - kNUMBEROFMESSAGES
        
        if minMessageNumber < 0 {
            minMessageNumber = 0
        }
        
        for i in minMessageNumber ..< maxMessageNumber {
            insertMessage(allLocalMessages[i])
        }
    }
    
    private func insertMessage(_ localMessage: LocalMessage) {
        
        if localMessage.senderId != User.currentId {
            markMesssageAsRead(localMessage)
        }
        
        let incoming = IncomingMessage(_collectionView: self)
        self.mkMessages.append(incoming.createMessage(localMessage: localMessage)!)
        displayingMessagesCount += 1
    }
    
    private func loadMoreMessage(maxNumber: Int, minNumber: Int) {
        
        maxMessageNumber = minNumber - 1
        minMessageNumber = maxMessageNumber - kNUMBEROFMESSAGES
        
        if minMessageNumber < 0 {
            minMessageNumber = 0
        }
        
        for i in (minMessageNumber ... maxMessageNumber).reversed() {
            insertOlderMessage(allLocalMessages[i])
        }
    }
    
    private func insertOlderMessage(_ localMessage: LocalMessage) {
        
        let incoming = IncomingMessage(_collectionView: self)
        self.mkMessages.insert(incoming.createMessage(localMessage: localMessage)!, at: 0)
        displayingMessagesCount += 1
    }
    
    private func markMesssageAsRead(_ localMessage: LocalMessage) {
        
        if localMessage.senderId != User.currentId && localMessage.status != kREAD {
            FirebaseMassageListener.shared.updateMessageInFirebase(localMessage, memberIds: [User.currentId, recipientId])
        }
        
    }
    
    //MARK: - IBActions
    func messageSend(text: String?, photo: UIImage?, video: Video?, audio: String?, location: String?, audioDuration: Float = 0.0) {
        
        OutgoingMessage.send(chatId: chatId, text: text, photo: photo, video: video, audio: audio, audioDuration: audioDuration, location: location, memberIds: [User.currentId, recipientId])
    }
    
    @objc private func backButtonPressed() {
        FirebaseRecentListener.shared.resetRecentCounter(chatRoomId: chatId)
        removeListeners()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func actionAttachMessage() {
        
        messageInputBar.inputTextView.resignFirstResponder()
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePhotoOrVideo = UIAlertAction(title: "Camera", style: .default) { (alert) in
            self.showImageGallery(camera: true)
        }
        
        let shareMedia = UIAlertAction(title: "Library", style: .default) { (alert) in
            self.showImageGallery(camera: false)
        }
        
        let shareLocation = UIAlertAction(title: "Share Location", style: .default) { (alert) in
            
            if let _ = LocationManager.shared.currentLocation {
                
                self.messageSend(text: nil, photo: nil, video: nil, audio: nil, location: kLOCATION)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        takePhotoOrVideo.setValue(UIImage(systemName: "camera"), forKey: "image")
        shareMedia.setValue(UIImage(systemName: "photo.fill"), forKey: "image")
        shareLocation.setValue(UIImage(systemName: "mappin.and.ellipse"), forKey: "image")

        optionMenu.addAction(takePhotoOrVideo)
        optionMenu.addAction(shareMedia)
        optionMenu.addAction(shareLocation)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    //MARK: - Update Typind indicator
    func createTypingObserver() {
        FirebaseTypingListener.shared.createTypingObserver(chatRoomId: chatId) { (isTyping) in
            
            DispatchQueue.main.async {
                self.updateTypingIndicator(isTyping)
            }
            
        }
    }
    
    func typingIndicatorUpdate() {
        
        typingCounter += 1
        FirebaseTypingListener.saveTypingCounter(typing: true, chatRoomId: chatId)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.typingCounterStop()
        }
    }
    
    private func typingCounterStop() {
        typingCounter -= 1
        
        if typingCounter == 0 {
            FirebaseTypingListener.saveTypingCounter(typing: false, chatRoomId: chatId)
        }
    }
    
    func updateTypingIndicator(_ show: Bool) {
        subTitleLabel.text = show ? "Typing..." : ""
    }
    
    //MARK: - Gallery
    private func showImageGallery(camera: Bool) {
        
        galllery =  GalleryController()
        galllery.delegate = self
        Config.tabsToShow = camera ? [.cameraTab] : [.imageTab, .videoTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        Config.VideoEditor.maximumDuration = 30
        galllery.modalPresentationStyle = .fullScreen
        self.present(galllery, animated: true, completion: nil)
    }
    
    //MARK: - AudioMessages
    @objc func recordAudio() {
        
        switch longPressGesture.state {
        
        case .began:
            
            audioDuration = Date()
            audioFileName = Date().stringDate()
            AudioRecorder.shared.startRecording(fileName: audioFileName)
            
        case .ended:

            AudioRecorder.shared.finishRecording()
            if fileExistsAtPath(path: audioFileName + ".m4a") {
                
                let audioD = audioDuration.interval(ofComponent: .second, from: Date())
                messageSend(text: nil, photo: nil, video: nil, audio: audioFileName, location: nil, audioDuration: audioD)
            } else {
                print("no audio file")
            }
            
            audioFileName = ""
            
        @unknown default:
            print("unknown")
        }
    }
}

extension ChatRoomVC: GalleryControllerDelegate {
    
    //MARK: - Gallery Delegate
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            images.first!.resolve { (image) in
                self.messageSend(text: nil, photo: image, video: nil, audio: nil, location: nil)
            }
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        
        self.messageSend(text: nil, photo: nil, video: video, audio: nil, location: nil)
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
