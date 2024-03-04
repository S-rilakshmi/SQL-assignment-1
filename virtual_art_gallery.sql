create database virtual_art_gallery;
use virtual_art_gallery;

-- Create the Artists table
CREATE TABLE Artists ( 
ArtistID INT PRIMARY KEY, 
Name VARCHAR(255) NOT NULL, 
Biography TEXT, 
Nationality VARCHAR(100)); 

-- Create the Categories table 
CREATE TABLE Categories ( 
CategoryID INT PRIMARY KEY, 
Name VARCHAR(100) NOT NULL);

-- Create the Artworks table 
CREATE TABLE Artworks ( 
ArtworkID INT PRIMARY KEY, 
Title VARCHAR(255) NOT NULL, 
ArtistID INT, 
CategoryID INT, 
Year INT, 
Description TEXT, 
ImageURL VARCHAR(255), 
FOREIGN KEY (ArtistID) REFERENCES Artists (ArtistID), 
FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID)); 

-- Create the Exhibitions table 
CREATE TABLE Exhibitions ( 
ExhibitionID INT PRIMARY KEY, 
Title VARCHAR(255) NOT NULL, 
StartDate DATE, 
EndDate DATE, 
Description TEXT);

-- Create a table to associate artworks with exhibitions 
CREATE TABLE ExhibitionArtworks ( 
ExhibitionID INT, 
ArtworkID INT, 
PRIMARY KEY (ExhibitionID, ArtworkID), 
FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions (ExhibitionID), 
FOREIGN KEY (ArtworkID) REFERENCES Artworks (ArtworkID)); 

-- Insert sample data into the Artists table 
INSERT INTO Artists (ArtistID, Name, Biography, Nationality) VALUES 
(1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'), 
(2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'), 
(3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian'); 


-- Insert sample data into the Categories table 
INSERT INTO Categories (CategoryID, Name) VALUES 
(1, 'Painting'), 
(2, 'Sculpture'), 
(3, 'Photography');

-- Insert sample data into the Artworks table 
INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES 
(1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'), 
(2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'), 
(3, 'Guernica', 1, 1, 1937, 'Pablo Picasso\'s powerful anti-war mural.', 'guernica.jpg'); 

-- Insert sample data into the Exhibitions table 
INSERT INTO Exhibitions (ExhibitionID, Title, StartDate, EndDate, Description) VALUES 
(1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'), 
(2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.');

-- Insert artworks into exhibitions 
INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES 
(1, 1), 
(1, 2), 
(1, 3), 
(2, 2);

/*Task1 Retrieve the names of all artists along with the number of artworks they have in the gallery, and 
list them in descending order of the number of artworks.*/ 
select a.name as ArtistName,count(w.artworkid) as NumberofArtwork from artists a left join artworks w on a.artistid=w.artistid group by a.artistid,a.name order by NumberofArtwork desc;

/*Task2 List the titles of artworks created by artists from 'Spanish' and 'Dutch' nationalities, and order 
them by the year in ascending order. */ 
select w.title as ArtworkTitle, a.name as ArtistName, w.year from Artworks w join artists a on w.artistid=a.artistid where a.nationality in('Spanish', 'Dutch') order by w.year asc;

/*Task3 Find the names of all artists who have artworks in the 'Painting' category, and the number of 
artworks they have in this category. */ 
select a.name as ArtistName, count(w.artworkid) as NumberofArtworksInPainting from artists a join artworks w on a.artistid=w.artistid join categories c on w.categoryid=c.categoryid where c.name='Painting' group by a.artistid,a.name;

/*Task4 List the names of artworks from the 'Modern Art Masterpieces' exhibition, along with their 
artists and categories. */ 
select w.title as ArtworkTitle, a.name as ArtistName, c.name as categoryName from artworks w join artists a on w.artistid=a.artistid join categories c on w.categoryid=c.categoryid join exhibitionartworks ea on w.artworkid=ea.artworkid join exhibitions e on ea.exhibitionid=e.exhibitionid where e.title='Modern Art Masterpieces';

/*Task5 Find the artists who have more than two artworks in the gallery. */ 
select a.name as ArtistName, count(w.artworkid) as NumberofArtworks from artists a join artworks w on a.artistid=w.artistid group by a.artistid, a.name having NumberofArtworks>2;

/*Task6 Find the titles of artworks that were exhibited in both 'Modern Art Masterpieces' and 
'Renaissance Art' exhibitions*/ 
select  w.title as ArtworkTitle from Artworks w join exhibitionartworks ea on w.artworkid=ea.artworkid join exhibitions e on ea.exhibitionid=e.exhibitionid where e.title in ('Modern Art Masterpieces', 'Renaissance Art') group by w.artworkid,w.title having count(distinct e.exhibitionid)=2;

/*Task7 Find the total number of artworks in each category */ 
select c.name as CategoryName, count(w.artworkid)as NumberofArtwork from categories c left join artworks w on c.categoryid=w.categoryid group by c.categoryid, c.name;

/*Task8 List artists who have more than 3 artworks in the gallery. */ 
select a.name as ArtistName,count(w.artworkid) as NumberofArtwork from artists a join artworks w on a.artistid=w.artistid group by a.artistid,a.name having NumberofArtwork >3;

/*Task9 Find the artworks created by artists from a specific nationality (e.g., Spanish). */ 
select w.title as ArtworkTitle, a.name as ArtistName, a.nationality from Artworks w join artists a on w.artistid=a.artistid where a.nationality ='Spanish';

/*Task10  List exhibitions that feature artwork by both Vincent van Gogh and Leonardo da Vinci. */ 
select e.exhibitionid,e.title as ExhibitionTitle,e.startdate,e.enddate,e.description from exhibitions e join ExhibitionArtworks ea ON e.ExhibitionID = ea.ExhibitionID join  Artworks w ON ea.ArtworkID = w.ArtworkID join Artists a ON w.ArtistID = a.ArtistID where a.Name IN ('Vincent van Gogh', 'Leonardo da Vinci') group by e.ExhibitionID, e.Title, e.StartDate, e.EndDate, e.Description having COUNT(DISTINCT a.Artistid) = 2;

/*Task11  Find all the artworks that have not been included in any exhibition.*/ 
select w.title as ArtworkTitle, a.name as ArtistName,c.name as CategoryName from Artworks w join artists a on w.artistid=a.artistid join categories c on w.categoryid=c.categoryid where w.artworkid not in (select artworkid from exhibitionartworks);

/*Task12 List artists who have created artworks in all available categories.*/ 
select a.name as ArtistName from artists a join artworks w on a.artistid = w.artistid join categories c on w.categoryid=c.categoryid group by a.artistid,a.name having count(distinct c.categoryid)=(select count(*) from categories);

/*Task13  List the total number of artworks in each category. */ 
select c.name as categoryName,count(w.artworkid)as NumberofArtworks from categories c left join artworks w on c.categoryid=w.categoryid group by c.categoryid,c.name;

/*Task14 Find the artists who have more than 2 artworks in the gallery. */ 
select a.name as ArtistName, count(w.artworkid) as NumberofArtworks from artists a join artworks w on a.artistid=w.artistid group by a.artistid, a.name having NumberofArtworks >2;

/*Task15 List the categories with the average year of artworks they contain, only for categories with more 
than 1 artwork. */ 
select c.name as categoryname,avg(w.year)as AverageYear from categories c join artworks w on c.categoryid=w.categoryid group by c.categoryid, c.name having count(w.artworkid)>1;

/*Task16 Find the artworks that were exhibited in the 'Modern Art Masterpieces' exhibition. */ 
select w.title as Artworktitle, a.name as ArtistName, a.name As categoryName from artworks w join exhibitionartworks ea on w.artworkid=ea.artworkid join exhibitions e on ea.exhibitionid=e.exhibitionid join artists a on w.artistid=a.artistid join categories c on w.categoryid=c.categoryid where e.title='Modern Art Masterpieces';

/*Task17 Find the categories where the average year of artworks is greater than the average year of all 
artworks. */ 
select c.name as categoryName, avg(w.year) as AverageYear from categories c join artworks w on c.categoryid=w.categoryid group by c.categoryid,c.name having count(w.artworkid)>1;

/*Task18 List the artworks that were not exhibited in any exhibition.*/ 
select w.title as ArtworkTitle, e.title as exhibitionTitle from artworks w join exhibitionartworks ea on w.artworkid=ea.artworkid join exhibitions e on ea.exhibitionid=e.exhibitionid where e.title='Modern Art Masterpieces';

/*Task19 Show artists who have artworks in the same category as "Mona Lisa." */ 
select distinct a.name as ArtistName from artists a join artworks w on a.artistid=w.artistid join categories c on w.categoryid where c.name ='Painting' AND w.ArtworkID <> (SELECT ArtworkID FROM Artworks WHERE title = 'Mona Lisa');

/*Task20 List the names of artists and the number of artworks they have in the gallery. */ 
select a.name as Artistname, count(w.artworkid) as NumberOfArtworks from Artists a left join artworks w on a.artistid=w.artistid group by a.artistid,a.name;

